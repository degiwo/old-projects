library(keras)
library(imager)

# prepare images ----------------------------------------------------------

get_images <- function(path, pixel1, pixel2) {
  files <- list.files(file.path(path))
  list_img <- list()
  list_filenames <- list()

  for (i in seq(files)) {
    img <- file.path(path, files[i]) %>%
      load.image() %>%
      resize(pixel1, pixel2) %>%
      grayscale() %>%
      as.data.frame()

    list_img[[i]] <- img$value
    list_filenames[[i]] <- files[i]
  }

  images <- do.call(rbind, list_img)
  filenames <- unlist(list_filenames)

  return(list(images = images, filenames = filenames))
}

img1 <- get_images(file.path("dev/Brezen"), 28, 28)
img2 <- get_images(file.path("dev/Semmeln"), 28, 28)

all_images <- rbind(img1, img2)
all_labels <- c(rep(0, nrow(img1)), rep(1, nrow(img2)))


# train model -------------------------------------------------------------

set.seed(123)

train_index <- sample(c(FALSE, TRUE),
                      size = nrow(all_images),
                      replace = TRUE,
                      prob = c(0.4, 0.6))
train_images <- all_images[train_index, ] %>%
  array_reshape(c(sum(train_index), 28, 28, 1))
train_labels <- all_labels[train_index] %>%
  to_categorical()
test_images <- all_images[!train_index, ] %>%
  array_reshape(c(sum(!train_index), 28, 28, 1))
test_labels <- all_labels[!train_index] %>%
  to_categorical()

model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32,
                kernel_size = c(3, 3),
                activation = "relu",
                input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dense(units = 256, activation = "relu") %>%
  layer_dense(units = 2, activation = "softmax")

model %>%
  compile(
    optimizer = "rmsprop",
    loss = "categorical_crossentropy",
    metrics = c("accuracy")
  )

model %>%
  fit(train_images, train_labels, epochs = 10, batch_size = 8)

model %>%
  evaluate(test_images, test_labels)

save_model_hdf5(model, filepath = "dev/nn_model.h5")

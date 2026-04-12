import { Component, signal, computed } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { environment } from '../environments/environment';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly russian = signal('');
  protected readonly transliteration = signal('');
  protected readonly german = signal('');
  protected readonly errorMessage = signal('');
  protected readonly isTranslationExpanded = signal(false);
  protected readonly mode = signal<'ru-de' | 'de-ru'>('ru-de');

  protected readonly primaryText = computed(() => {
    return this.mode() === 'ru-de' ? `${this.russian()} (${this.transliteration()})` : this.german();
  });

  protected readonly translationText = computed(() => {
    return this.mode() === 'ru-de' ? this.german() : `${this.russian()} (${this.transliteration()})`;
  });

  protected readonly translationLabel = computed(() => {
    return this.mode() === 'ru-de' ? 'Deutsch' : 'Русский';
  });

  protected async fetchItem(): Promise<void> {
    this.isTranslationExpanded.set(false);
    this.errorMessage.set('');
    
    try {
      const response = await fetch(`${environment.apiUrl}/words`);
      if (!response.ok) {
        this.errorMessage.set(`Error: ${response.status} ${response.statusText}`);
        return;
      }

      const data = await response.json();
      this.russian.set(data.russian);
      this.transliteration.set(data.transliteration);
      this.german.set(data.german);
    } catch (error) {
      this.errorMessage.set('Error during loading');
    }
  }

  protected toggleTranslation(): void {
    this.isTranslationExpanded.update(expanded => !expanded);
  }
}

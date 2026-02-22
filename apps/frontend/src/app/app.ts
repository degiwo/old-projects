import { Component, inject, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { FormControl, ReactiveFormsModule, FormGroup } from '@angular/forms';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, ReactiveFormsModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('frontend');
  private http = inject(HttpClient);

  result = new FormGroup({
    score: new FormControl(0),
    score_opponent: new FormControl(0),
    name_opponent: new FormControl('')
  });

  onSave() {
    console.log(this.result.value);
    this.http.post('http://localhost:8000/result?score=' + this.result.value.score + '&score_opponent=' + this.result.value.score_opponent + '&name_opponent=' + this.result.value.name_opponent, {}).subscribe(response => {
      console.log(response);
    });
  }
}

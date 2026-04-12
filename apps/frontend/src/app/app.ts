import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { environment } from '../environments/environment';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly responseMessage = signal('');

  protected async fetchItem(): Promise<void> {
    try {
      const response = await fetch(`${environment.apiUrl}/words`);
      if (!response.ok) {
        this.responseMessage.set(`Error: ${response.status} ${response.statusText}`);
        return;
      }

      const data = await response.json();
      this.responseMessage.set(`${data.russian}, ${data.german}`);
    } catch (error) {
      this.responseMessage.set('Error during loading');
    }
  }
}

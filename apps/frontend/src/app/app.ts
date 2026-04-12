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
      const response = await fetch(`${environment.apiUrl}/items/1`);
      if (!response.ok) {
        this.responseMessage.set(`Fehler: ${response.status} ${response.statusText}`);
        return;
      }

      const data = await response.json();
      this.responseMessage.set(`item_id=${data.item_id}, q=${data.q}`);
    } catch (error) {
      this.responseMessage.set('Fehler beim Laden des Items');
    }
  }
}

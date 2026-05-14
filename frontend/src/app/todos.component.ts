import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClientModule, HttpClient } from '@angular/common/http';

interface Todo {
  id?: number;
  title: string;
  completed: boolean;
}

@Component({
  selector: 'app-todos',
  standalone: true,
  imports: [CommonModule, FormsModule, HttpClientModule],
  templateUrl: './todos.component.html'
})
export class TodosComponent implements OnInit {
  todos: Todo[] = [];
  newTitle = '';

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.load();
  }

  load() {
    this.http.get<Todo[]>('/api/todos/').subscribe(data => this.todos = data || []);
  }

  add() {
    const payload = { title: this.newTitle, completed: false };
    this.http.post<Todo>('/api/todos/', payload).subscribe(() => { this.newTitle = ''; this.load(); });
  }

  toggle(todo: Todo) {
    const payload = { title: todo.title, completed: !todo.completed };
    this.http.put<Todo>(`/api/todos/${todo.id}`, payload).subscribe(() => this.load());
  }

  delete(todo: Todo) {
    this.http.delete(`/api/todos/${todo.id}`).subscribe(() => this.load());
  }
}

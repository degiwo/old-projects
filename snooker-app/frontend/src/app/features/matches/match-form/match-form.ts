import { Component } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';

@Component({
  selector: 'app-match-form',
  imports: [ReactiveFormsModule],
  templateUrl: './match-form.html',
  styleUrls: ['./match-form.scss'],
})
export class MatchForm {
  form = new FormGroup({
    opponent: new FormControl('', Validators.required),
  });

  submit(): void {
    console.log(this.form.value);
  }
}

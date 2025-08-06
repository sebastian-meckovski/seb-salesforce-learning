import { LightningElement } from 'lwc';
import createBook from '@salesforce/apex/BookController.createBook';

export default class AddBook extends LightningElement {
    title = '';
    author = '';
    rating = 1;
    review = '';
    message = '';
    error = '';

    handleTitleChange(event) {
        this.title = event.target.value;
    }
    handleAuthorChange(event) {
        this.author = event.target.value;
    }
    handleRatingChange(event) {
        this.rating = event.target.value;
    }
    handleReviewChange(event) {
        this.review = event.target.value;
    }

    async handleAddBook() {
        this.message = '';
        this.error = '';
        try {
            await createBook({ 
                title: this.title, 
                author: this.author, 
                rating: parseInt(this.rating, 10), 
                review: this.review 
            });
            this.message = 'Book added successfully!';
            // Optionally reset fields
            this.title = '';
            this.author = '';
            this.rating = 1;
            this.review = '';
        } catch (err) {
            this.error = 'Error adding book: ' + (err.body ? err.body.message : err.message);
        }
    }
}
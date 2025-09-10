import { LightningElement, wire } from 'lwc';
import createBook from '@salesforce/apex/BookController.createBook';
import { publish, MessageContext } from 'lightning/messageService';
import BOOK_ADDED_CHANNEL from '@salesforce/messageChannel/BookAdded__c';

export default class AddBook extends LightningElement {
    title = '';
    author = '';
    rating = 1;
    review = '';
    message = '';
    error = '';

    @wire(MessageContext)
    messageContext;

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
            const result = await createBook({
                title: this.title,
                author: this.author,
                rating: parseInt(this.rating, 10),
                review: this.review
            });
            this.message = 'Book added successfully!';

            // Publish message to refresh book list
            const payload = { bookId: result.Id };
            publish(this.messageContext, BOOK_ADDED_CHANNEL, payload);

            // Reset fields
            this.title = '';
            this.author = '';
            this.rating = 1;
            this.review = '';
        } catch (err) {
            this.error = 'Error adding book: ' + (err.body ? err.body.message : err.message);
        }
    }
}
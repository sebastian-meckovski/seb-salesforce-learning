import { LightningElement, track, wire } from 'lwc';
import getBooks from '@salesforce/apex/BookController.getBooks';
import updateBookRating from '@salesforce/apex/BookController.updateBookRating';
import deleteBook from '@salesforce/apex/BookController.deleteBook';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { subscribe, MessageContext, unsubscribe } from 'lightning/messageService';
import BOOK_ADDED_CHANNEL from '@salesforce/messageChannel/BookAdded__c';

export default class BookList extends LightningElement {
    @track ratingEdits = {};
    @wire(getBooks) books;
    @wire(MessageContext) messageContext;
    subscription = null;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                BOOK_ADDED_CHANNEL,
                (message) => this.handleBookAdded(message)
            );
        }
    }

    unsubscribeToMessageChannel() {
        if (this.subscription) {
            unsubscribe(this.subscription);
            this.subscription = null;
        }
    }

    handleBookAdded(message) {
        // Refresh the books list when a new book is added
        refreshApex(this.books);
    }

    handleRatingInput(event) {
        const bookId = event.target.dataset.id;
        this.ratingEdits = { ...this.ratingEdits, [bookId]: event.target.value };
    }

    async handleSaveRating(event) {
        const bookId = event.target.dataset.id;
        const newRating = parseFloat(this.ratingEdits[bookId]);
        try {
            await updateBookRating({ bookId, newRating });
            this.ratingEdits = { ...this.ratingEdits, [bookId]: '' };
            // Refresh the wire adapter
            await refreshApex(this.books);
            this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: 'Rating updated', variant: 'success' }));
        } catch (err) {
            // Optionally handle error
            // eslint-disable-next-line no-console
            console.error('Error updating rating', err);
            this.dispatchEvent(new ShowToastEvent({ title: 'Error updating rating', message: err.body ? err.body.message : err.message, variant: 'error' }));
        }
    }

    async handleDeleteBook(event) {
        const bookId = event.target.dataset.id;
        try {
            // Simple confirm
            // eslint-disable-next-line no-alert
            if (!confirm('Are you sure you want to delete this book?')) {
                return;
            }
            await deleteBook({ bookId });
            await refreshApex(this.books);
            this.dispatchEvent(new ShowToastEvent({ title: 'Deleted', message: 'Book deleted', variant: 'success' }));
        } catch (err) {
            // eslint-disable-next-line no-console
            console.error('Error deleting book', err);
            this.dispatchEvent(new ShowToastEvent({ title: 'Error deleting book', message: err.body ? err.body.message : err.message, variant: 'error' }));
        }
    }
}
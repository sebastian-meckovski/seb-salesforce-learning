import { LightningElement, track, wire } from 'lwc';
import getBooks from '@salesforce/apex/BookController.getBooks';
import updateBookRating from '@salesforce/apex/BookController.updateBookRating';
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
        } catch (err) {
            // Optionally handle error
            // eslint-disable-next-line no-console
            console.error('Error updating rating', err);
        }
    }
}
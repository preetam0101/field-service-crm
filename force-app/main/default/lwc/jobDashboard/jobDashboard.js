import { LightningElement, wire, track } from 'lwc';
import getJobs from '@salesforce/apex/JobDashboardController.getJobs';

const COLUMNS = [
    { label: 'Job Name', fieldName: 'Name', type: 'text' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' },
    { label: 'Priority', fieldName: 'Priority__c', type: 'text' },
    { label: 'Scheduled Date', fieldName: 'Scheduled_Date__c', type: 'date' },
    { label: 'Client Name', fieldName: 'Client_Name__c', type: 'text' }
];

export default class JobDashboard extends LightningElement {
    
    @track filteredJobs = [];
    @track allVariant = 'brand';
    @track openVariant = 'neutral';
    @track completedVariant = 'neutral';
    
    allJobs = [];
    
    // Fetch jobs from Apex
    @wire(getJobs)
    wiredJobs({ error, data }) {
        if (data) {
            this.allJobs = data;
            this.filteredJobs = data;
        } else if (error) {
            console.error('Error fetching jobs:', error);
        }
    }
    
    // Column definitions
    get columns() {
        return COLUMNS;
    }
    
    // Filter - All Jobs
    handleFilterAll() {
        this.filteredJobs = this.allJobs;
        this.allVariant = 'brand';
        this.openVariant = 'neutral';
        this.completedVariant = 'neutral';
    }
    
    // Filter - Open Jobs
    handleFilterOpen() {
        this.filteredJobs = this.allJobs.filter(job => 
            job.Status__c !== 'Completed'
        );
        this.allVariant = 'neutral';
        this.openVariant = 'brand';
        this.completedVariant = 'neutral';
    }
    
    // Filter - Completed Jobs
    handleFilterCompleted() {
        this.filteredJobs = this.allJobs.filter(job => 
            job.Status__c === 'Completed'
        );
        this.allVariant = 'neutral';
        this.openVariant = 'neutral';
        this.completedVariant = 'brand';
    }
}
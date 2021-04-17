import {firestore} from 'firebase-admin';

export type Status = 'NEW' | 'ACCEPTED' | 'REACHED_PICKUP' | 'STARTED_RIDE' | 'REACHED_DROPOFF' | 'CANCELLED' | undefined;

export interface User {
	id: string;
	email: string;
	phone: string;
}

export interface Driver {
	device_id: string;
	name: string;
	email: string;
	phone: string;
	available: string;
	license_plate: string;
}

export interface Order {
	status: Status;
	trip_id: string;
	pickup: firestore.GeoPoint;
	dropoff: firestore.GeoPoint;
	rider: User;
	driver: Driver;
	created_at: firestore.Timestamp;
	updated_at: firestore.Timestamp;
	queue_position: number;
	wait_estimate: number;
}

export interface Trip {}
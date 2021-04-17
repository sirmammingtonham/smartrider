import {firestore} from 'firebase-admin';

export type Status = 'NEW' | 'ACCEPTED' | 'REACHED_PICKUP' | 'STARTED_RIDE' | 'REACHED_DROPOFF' | 'CANCELLED' | undefined;

export interface User {
	id: string;
	email: string;
	phone: string;
}

export interface Driver {
	ref: firestore.DocumentReference;
	device_id: string;
	name: string;
	email: string;
	phone: string;
	available: string;
	license_plate: string;
}

export interface Estimate {
	arrive_at: string;
	route: {
		distance: number;
		duration: number;
		remaining_duration: number;
		start_place: string;
		end_place: string;
		polyline: any; //GeoJSON object
	};

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
	estimate: Estimate;
}

export interface Trip {}
import {Entity, model, property, hasMany} from '@loopback/repository';
import {User} from './user.model';

@model()
export class StalkerList extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  id?: number;

  @hasMany(() => User)
  users: User[];

  constructor(data?: Partial<StalkerList>) {
    super(data);
  }
}

export interface StalkerListRelations {
  // describe navigational properties here
}

export type StalkerListWithRelations = StalkerList & StalkerListRelations;

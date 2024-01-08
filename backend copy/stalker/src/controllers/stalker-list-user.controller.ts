import {
  Count,
  CountSchema,
  Filter,
  repository,
  Where,
} from '@loopback/repository';
import {
  del,
  get,
  getModelSchemaRef,
  getWhereSchemaFor,
  param,
  patch,
  post,
  requestBody,
} from '@loopback/rest';
import {
  StalkerList,
  User,
} from '../models';
import {StalkerListRepository} from '../repositories';

export class StalkerListUserController {
  constructor(
    @repository(StalkerListRepository) protected stalkerListRepository: StalkerListRepository,
  ) { }

  @get('/stalker-lists/{id}/users', {
    responses: {
      '200': {
        description: 'Array of StalkerList has many User',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(User)},
          },
        },
      },
    },
  })
  async find(
    @param.path.number('id') id: number,
    @param.query.object('filter') filter?: Filter<User>,
  ): Promise<User[]> {
    return this.stalkerListRepository.users(id).find(filter);
  }

  @post('/stalker-lists/{id}/users', {
    responses: {
      '200': {
        description: 'StalkerList model instance',
        content: {'application/json': {schema: getModelSchemaRef(User)}},
      },
    },
  })
  async create(
    @param.path.number('id') id: typeof StalkerList.prototype.id,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(User, {
            title: 'NewUserInStalkerList',
            exclude: ['id'],
            optional: ['stalkerListId']
          }),
        },
      },
    }) user: Omit<User, 'id'>,
  ): Promise<User> {
    return this.stalkerListRepository.users(id).create(user);
  }

  @patch('/stalker-lists/{id}/users', {
    responses: {
      '200': {
        description: 'StalkerList.User PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async patch(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(User, {partial: true}),
        },
      },
    })
    user: Partial<User>,
    @param.query.object('where', getWhereSchemaFor(User)) where?: Where<User>,
  ): Promise<Count> {
    return this.stalkerListRepository.users(id).patch(user, where);
  }

  @del('/stalker-lists/{id}/users', {
    responses: {
      '200': {
        description: 'StalkerList.User DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.number('id') id: number,
    @param.query.object('where', getWhereSchemaFor(User)) where?: Where<User>,
  ): Promise<Count> {
    return this.stalkerListRepository.users(id).delete(where);
  }
}

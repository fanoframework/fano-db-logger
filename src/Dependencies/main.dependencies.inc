(*!------------------------------------------------------------
 * [[APP_NAME]] ([[APP_URL]])
 *
 * @link      [[APP_REPOSITORY_URL]]
 * @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]
 * @license   [[LICENSE_URL]] ([[LICENSE]])
 *------------------------------------------------------------- *)

{---put your main dependencies registration here---}
container.add('db', TMySqlDbFactory.create(
    config.getString('db.mysql.version'),
    config.getString('db.mysql.host'),
    config.getString('db.mysql.database'),
    config.getString('db.mysql.username'),
    config.getString('db.mysql.password'),
    config.getInt('db.mysql.port')
));
container.add('logger', TDbLoggerFactory.create());

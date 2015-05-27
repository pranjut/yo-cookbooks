CREATE TABLE `users` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, `name` VARCHAR(254) NOT NULL, `email` VARCHAR(254) NOT NULL, `password` VARCHAR(254) NOT NULL);
CREATE UNIQUE INDEX `idx_email` ON `users` (`email`);
CREATE TABLE `user_profiles` (`user_id` BIGINT NOT NULL, `facebook_id` VARCHAR(254), `linkedin_id` VARCHAR(254), `twitter_id` VARCHAR(254), `profile_image_url` VARCHAR(254), `profile_title` VARCHAR(254), `resume` VARCHAR(254), `language` VARCHAR(254), `website` VARCHAR(254));
CREATE UNIQUE INDEX `idx_userId` ON `user_profiles` (`user_id`);
ALTER TABLE `user_profiles` ADD CONSTRAINT `user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;
CREATE TABLE `privacy_settings` (`receieve_emails` BOOLEAN DEFAULT FALSE NOT NULL, `show_profile` BOOLEAN DEFAULT FALSE NOT NULL, `show_courses` BOOLEAN DEFAULT FALSE NOT NULL, `facebook_share_subscriptions_with_friends` BOOLEAN DEFAULT FALSE NOT NULL, `facebook_share_views_with_friends` BOOLEAN DEFAULT FALSE NOT NULL, `user_id` BIGINT NOT NULL);
CREATE UNIQUE INDEX `idx_userId` ON `privacy_settings` (`user_id`);
CREATE TABLE `notification_settings` (`receive_proversity_announcements` BOOLEAN DEFAULT FALSE NOT NULL, `receive_course_of_the_week_announcements` BOOLEAN DEFAULT FALSE NOT NULL, `receive_weekly_recommendations` BOOLEAN DEFAULT FALSE NOT NULL, `receive_emails_on_message` BOOLEAN DEFAULT FALSE NOT NULL, `receive_email_on_new_followers` BOOLEAN DEFAULT FALSE NOT NULL, `receive_no_email_notifications` BOOLEAN DEFAULT FALSE NOT NULL, `user_id` BIGINT NOT NULL);
CREATE UNIQUE INDEX `idx_userId` ON `notification_settings` (`user_id`);
CREATE TABLE `screencasts` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, `title` VARCHAR(254) NOT NULL, `description` VARCHAR(254) NOT NULL, `language` INTEGER DEFAULT 1 NOT NULL, `keywords` VARCHAR(254) NOT NULL, `user_id` BIGINT NOT NULL, `screencast_category_id` BIGINT NOT NULL, `screencast_state` INTEGER DEFAULT 1 NOT NULL, `screencast_price` BIGINT NOT NULL);
CREATE UNIQUE INDEX `constraint` ON `screencasts` (`title`);
CREATE TABLE `tags` (`tag` VARCHAR(254) NOT NULL, `screen_id` BIGINT NOT NULL);
CREATE TABLE `chapter` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, `title` VARCHAR(254), `description` VARCHAR(254), `sequence` BIGINT, `video` VARCHAR(254), `thumbnail` VARCHAR(254), `free` BOOLEAN NOT NULL, `screencast_id` BIGINT NOT NULL);
CREATE TABLE `screencast_category` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, `code` VARCHAR(254) NOT NULL, `description` VARCHAR(254) NOT NULL);
CREATE TABLE `screencast_price` (`screencast_id` BIGINT NOT NULL PRIMARY KEY, `currency` INTEGER NOT NULL, `price` DOUBLE NOT NULL);
CREATE TABLE `language` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, `name` VARCHAR(254) NOT NULL, `code` VARCHAR(254) NOT NULL);

CREATE TABLE `social_user` (`user_id` VARCHAR(254) NOT NULL, `provider_id` VARCHAR(254) NOT NULL, `first_name` VARCHAR(254), `last_name` VARCHAR(254), `full_name` VARCHAR(254), `email` VARCHAR(254), `avatar_url` VARCHAR(254), `auth_method` VARCHAR(254) NOT NULL, `token` VARCHAR(254), `secret` VARCHAR(254), `access_token` VARCHAR(254), `token_type` VARCHAR(254), `hasher` VARCHAR(254), `password` VARCHAR(254), `salt` VARCHAR(254));

ALTER TABLE `social_user` ADD CONSTRAINT `pk_identity` PRIMARY KEY (`user_id`, `provider_id`);
CREATE TABLE `token` (`uuid` VARCHAR(254) NOT NULL PRIMARY KEY, `email` VARCHAR(254) NOT NULL, `creation_time` TIMESTAMP NOT NULL, `expiration_time` TIMESTAMP NOT NULL, `is_sign_up` BOOLEAN NOT NULL);

create table question (id bigint not null auto_increment primary key, title varchar(500) not null, description varchar(500), post_date timestamp not null, user_id bigint not null, chapter_id bigint not null, is_resolved boolean);

alter table question add foreign key (user_id) references users(id);
alter table question add foreign key (chapter_id) references chapter(id);

create table answer (id bigint not null auto_increment primary key, description varchar(500), post_date timestamp, user_id bigint not null, question_id bigint not null, in_reply_to_id bigint default null, is_answer boolean);

alter table answer add foreign key (user_id) references users(id);
alter table answer add foreign key (question_id) references question(id);

create table featured_screencasts ( id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, screencast_id BIGINT NOT NULL, featured_from timestamp NOT NULL, featured_till timestamp NOT NULL );

alter table featured_screencasts add foreign key (screencast_id) references screencasts(id);

create table user_ratings( user_id bigint NOT NULL, screencast_id bigint NOT NULL, title varchar(40), review varchar(250), post_date timestamp, rating int NOT NULL);

alter table user_ratings add primary key (user_id, screencast_id);
alter table user_ratings add foreign key (user_id) references users(id);
alter table user_ratings add foreign key (screencast_id) references screencasts(id);

create table `roles` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,`name` VARCHAR(254) NOT NULL);

create table `user_roles` (`role_id` BIGINT NOT NULL,`user_id` BIGINT NOT NULL);

alter table `user_roles` add constraint `user_role_fk` foreign key(`user_id`) references `users`(`id`) on update NO ACTION on delete NO ACTION;

alter table `user_roles` add constraint `master_role_fk` foreign key(`role_id`) references `roles`(`id`) on update NO ACTION on delete NO ACTION;
create table `user_subscription` (`user_id` BIGINT NOT NULL,`screen_cast_id` BIGINT NOT NULL,`timestamp` TIMESTAMP NOT NULL);

alter table `user_subscription` add constraint `user_subscribed_user_fk` foreign key(`user_id`) references `users`(`id`) on update NO ACTION on delete NO ACTION;
alter table `user_subscription` add constraint `user_subscribed_screencast_fk` foreign key(`screen_cast_id`) references `screencasts`(`id`) on update NO ACTION on delete NO ACTION;

create table screencast_section ( id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, screencast_id BIGINT NOT NULL, sequence INT NOT NULL, title varchar(100) NOT NULL, content TEXT);

alter table screencast_section add foreign key (screencast_id) references screencasts(id);

create table screencast_file ( id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, screencast_id BIGINT NOT NULL, name VARCHAR(200) NOT NULL, url VARCHAR(500) NOT NULL);

alter table screencast_file add foreign key (screencast_id) references screencasts(id);

alter table screencast_file add constraint screencast_file_key unique (screencast_id, name);

create table `shopping_cart` (`user_id` BIGINT NOT NULL,`item_id` BIGINT NOT NULL);

CREATE TABLE logging_event_property
(
  event_id INT NOT NULL,
  mapped_key VARCHAR(254),
  mapped_value LONGTEXT
);
CREATE TABLE logging_event_exception
(
  event_id INT NOT NULL,
  id SMALLINT,
  trace_line VARCHAR(254)
);
CREATE TABLE logging_event
(
  timestamp BIGINT NOT NULL,
  formatted_message LONGTEXT,
  logger_name VARCHAR(254),
  level_string VARCHAR(10),
  reference_flag SMALLINT,
  caller_filename VARCHAR(254),
  caller_class VARCHAR(254),
  caller_method VARCHAR(254),
  caller_line CHAR(1),
  event_id INT
);


INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (1, 'EP', 'Entrepreneurship');
INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (2, 'GD', 'Graphic Design');
INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (3, 'PG', 'Photography');
INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (4, 'TG', 'Technology');
INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (5, 'CC', 'Cloud Computing');
INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (6, 'PR', 'Programming');
INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (7, 'WD', 'Web Design');
INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (8, 'AN', 'Programming');
INSERT INTO `screencast_category` (`id`, `code`, `description`) VALUES (9, 'CE', 'Competitive Exams');
INSERT INTO `language` (`id`, `code`, `name`)  VALUES (1, 'en-us', 'US English') ;

Alter Table `chapter` add column (chapter_state int );
Alter table `screencasts` drop column screencast_price;
ALTER TABLE `screencasts` ADD created_date timestamp NOT NULL ;
ALTER TABLE `screencasts` ADD last_modified_date timestamp NOT NULL ;
ALTER TABLE `screencasts` ADD image_url VARCHAR(254) ;
ALTER TABLE `screencasts`  CHANGE keywords punch_line VARCHAR(254);

CREATE
  DEFINER=`jsc`@`localhost`
TRIGGER `chapter_sequence_trigger`
BEFORE INSERT ON `chapter`
FOR EACH ROW
  SET New.sequence = ((select count(*) from `chapter` where screencast_id=new.screencast_id) +1)    ;


create table `coupons` (`coupon_code` VARCHAR(254) NOT NULL PRIMARY KEY,`discount` DOUBLE NOT NULL,`validity_end_date` DATE NOT NULL,`validity_start_date` DATE NOT NULL,`coupon_type` VARCHAR(254) NOT NULL);
create table `coupon_tags` (`coupon_code` VARCHAR(254) NOT NULL,`tag` VARCHAR(254) NOT NULL);
create table `user_transactions` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,`user_id` BIGINT NOT NULL,`transaction_date` DATE NOT NULL,`success` BOOLEAN NOT NULL,`payment_method` VARCHAR(254) NOT NULL);
create table `transaction_order` (`txn_id` BIGINT NOT NULL,`item_id` BIGINT NOT NULL,`actual_price` DOUBLE NOT NULL,`discounted_price` DOUBLE NOT NULL,`coupon_code` VARCHAR(254),`currency` INTEGER NOT NULL);
create table `item_discount` (`screencast_id` BIGINT NOT NULL,`coupon_code` VARCHAR(254) NOT NULL);
create table `user_voucher` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,`user_id` BIGINT NOT NULL,`voucher_id` BIGINT NOT NULL,`start_date` DATE NOT NULL,`end_date` DATE NOT NULL,`balance` DOUBLE NOT NULL);
create table `vouchers` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,`name` VARCHAR(254) NOT NULL,`amount` DOUBLE NOT NULL,`worth` DOUBLE NOT NULL,`validity_in_days` INTEGER NOT NULL);
CREATE TABLE `settings` (
  `setting` varchar(255) NOT NULL UNIQUE,
  `value` varchar(255) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_czech_ci;
CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8_czech_ci NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_czech_ci;
CREATE TABLE `services_status` (
  `id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_czech_ci;
CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `title` varchar(50) COLLATE utf8_czech_ci NOT NULL,
  `text` text COLLATE utf8_czech_ci NOT NULL,
  `time` int(11) NOT NULL,
  `end_time` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_czech_ci;
CREATE TABLE `tokens` (
  `token` varchar(64) COLLATE utf8_czech_ci NOT NULL,
  `user` int(11) NOT NULL,
  `expire` int(11) NOT NULL,
  `data` varchar(80) COLLATE utf8_czech_ci NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_czech_ci;
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(60) COLLATE utf8_czech_ci NOT NULL,
  `username` varchar(50) COLLATE utf8_czech_ci NOT NULL,
  `name` varchar(50) COLLATE utf8_czech_ci NOT NULL,
  `surname` varchar(50) COLLATE utf8_czech_ci NOT NULL,
  `password_hash` char(64) COLLATE utf8_czech_ci NOT NULL,
  `password_salt` char(64) COLLATE utf8_czech_ci NOT NULL,
  `permission` int(11) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_czech_ci;
CREATE TABLE `subscribers` (
  `subscriberID` int(11) NOT NULL,
  `telegramID` int(50) NOT NULL,
  `firstname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `services_subscriber` (
  `comboID` int(11) NOT NULL,
  `subscriberIDFK` int(11) NOT NULL,
  `serviceIDFK` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
CREATE TABLE queue_notify (
  id int(11) NOT NULL AUTO_INCREMENT,
  task_id int(11) NOT NULL,
  status tinyint(1) NOT NULL,
  subscriber_id int(11) NOT NULL,
  retries tinyint(1) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_czech_ci;
CREATE TABLE services_groups (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(50) NOT NULL,
  description varchar(50) DEFAULT NULL,
  visibility tinyint(4) NOT NULL,
  PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
CREATE TABLE queue_task (
  id int(11) NOT NULL AUTO_INCREMENT,
  type_id int(11) NOT NULL,
  status tinyint(1) NOT NULL,
  template_data1 text COLLATE utf8_czech_ci,
  template_data2 text COLLATE utf8_czech_ci,
  created_time int(11) NOT NULL,
  completed_time int(11) DEFAULT NULL,
  num_errors int(11) DEFAULT NULL,
  user_id int(11) NOT NULL,
  PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_czech_ci;
ALTER TABLE `services`
ADD PRIMARY KEY (`id`);
ALTER TABLE `services_status`
ADD PRIMARY KEY (`id`),
  ADD KEY `service_id` (`service_id`),
  ADD KEY `status_id` (`status_id`);
ALTER TABLE `status`
ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `tokens`
ADD PRIMARY KEY (`token`),
  ADD KEY `user` (`user`);
ALTER TABLE `users`
ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`);
ALTER TABLE `services`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `services_status`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `status`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `users`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `services_subscriber`
ADD PRIMARY KEY (`comboID`),
  ADD UNIQUE KEY `unique_subscription` (`subscriberIDFK`, `serviceIDFK`),
  ADD KEY `serviceIDFK` (`serviceIDFK`);
ALTER TABLE `subscribers`
ADD PRIMARY KEY (`subscriberID`),
  ADD UNIQUE KEY `telegramID` (`telegramID`);
ALTER TABLE `services_subscriber`
MODIFY `comboID` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `subscribers`
MODIFY `subscriberID` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `services_status`
ADD CONSTRAINT `service_id` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  ADD CONSTRAINT `status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`);
ALTER TABLE `status`
ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
ALTER TABLE `tokens`
ADD CONSTRAINT `user` FOREIGN KEY (`user`) REFERENCES `users` (`id`);
ALTER TABLE `services_subscriber`
ADD CONSTRAINT `services_subscriber_ibfk_1` FOREIGN KEY (`subscriberIDFK`) REFERENCES `subscribers` (`subscriberID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `services_subscriber_ibfk_2` FOREIGN KEY (`serviceIDFK`) REFERENCES `services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;
ALTER TABLE `subscribers` CHANGE COLUMN lastname lastname varchar(255) DEFAULT NULL;
# was varchar(255) NOT NULL
ALTER TABLE `subscribers` CHANGE COLUMN firstname firstname varchar(255) DEFAULT NULL;
# was varchar(255) NOT NULL
ALTER TABLE `subscribers` CHANGE COLUMN telegramID userID varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL;
ALTER TABLE `subscribers`
ADD COLUMN typeID tinyint(1) NOT NULL
AFTER subscriberID;
ALTER TABLE `subscribers`
ADD COLUMN token varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
AFTER lastname;
ALTER TABLE `subscribers`
ADD COLUMN expires int(11) DEFAULT NULL;
ALTER TABLE `subscribers`
ADD COLUMN active tinyint(1) DEFAULT NULL;
ALTER TABLE `subscribers`
ADD COLUMN create_time int(11) DEFAULT NULL;
ALTER TABLE `subscribers`
ADD COLUMN update_time int(11) DEFAULT NULL;
ALTER TABLE `subscribers` DROP INDEX telegramID;
# was UNIQUE (telegramID)
ALTER TABLE `subscribers`
ADD UNIQUE userID (userID);
COMMIT;
ALTER TABLE services
ADD COLUMN description varchar(200) COLLATE utf8_czech_ci NOT NULL;
ALTER TABLE services
ADD COLUMN group_id int(11) DEFAULT NULL;
ALTER TABLE services
ADD COLUMN url varchar(50) DEFAULT NULL;
INSERT INTO `users` (`id`, `email`, `username`, `name`, `surname`, `password_hash`, `password_salt`, `permission`, `active`)
VALUES ('1', '', 'Monitor', '', '', '', '', '2', '0');
COMMIT;
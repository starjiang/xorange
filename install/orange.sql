/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.7.21 : Database - orange
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`orange` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `orange`;

/*Table structure for table `api_persist_log` */

DROP TABLE IF EXISTS `api_persist_log`;

CREATE TABLE `api_persist_log` (
  `ip` varchar(20) NOT NULL DEFAULT '',
  `domain` varchar(50) NOT NULL DEFAULT '',
  `api` varchar(50) NOT NULL DEFAULT '',
  `stat_time` datetime NOT NULL,
  `request_2xx` int(11) NOT NULL DEFAULT '0',
  `request_3xx` int(11) NOT NULL DEFAULT '0',
  `request_4xx` int(11) NOT NULL DEFAULT '0',
  `request_5xx` int(11) NOT NULL DEFAULT '0',
  `total_request_count` int(11) NOT NULL DEFAULT '0',
  `total_success_request_count` int(11) NOT NULL DEFAULT '0',
  `avg_traffic_read` int(11) NOT NULL DEFAULT '0',
  `avg_traffic_write` int(11) NOT NULL DEFAULT '0',
  `avg_request_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ip`,`domain`,`api`,`stat_time`),
  KEY `ip` (`ip`),
  KEY `stat_time` (`stat_time`),
  KEY `domain` (`domain`),
  KEY `api` (`api`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `api_persist_log` */

/*Table structure for table `balancer` */

DROP TABLE IF EXISTS `balancer`;

CREATE TABLE `balancer` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(10240) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Data for the table `balancer` */

insert  into `balancer`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{\"selectors\":[]}','meta','2019-04-16 18:32:21');

/*Table structure for table `basic_auth` */

DROP TABLE IF EXISTS `basic_auth`;

CREATE TABLE `basic_auth` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `basic_auth` */

insert  into `basic_auth`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{}','meta','2016-11-11 11:11:11');

/*Table structure for table `cluster_node` */

DROP TABLE IF EXISTS `cluster_node`;

CREATE TABLE `cluster_node` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `ip` varchar(20) NOT NULL DEFAULT '',
  `port` smallint(6) DEFAULT '7777',
  `api_username` varchar(50) DEFAULT '',
  `api_password` varchar(50) DEFAULT '',
  `sync_status` varchar(2000) DEFAULT '',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`ip`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `cluster_node` */

/*Table structure for table `dashboard_user` */

DROP TABLE IF EXISTS `dashboard_user`;

CREATE TABLE `dashboard_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(60) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '密码',
  `is_admin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是管理员账户：0否，1是',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建或者更新时间',
  `enable` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否启用该用户：0否1是',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='dashboard users';

/*Data for the table `dashboard_user` */

insert  into `dashboard_user`(`id`,`username`,`password`,`is_admin`,`create_time`,`enable`) values (1,'admin','1fe832a7246fd19b7ea400a10d23d1894edfa3a5e09ee27e0c4a96eb0136763d',1,'2016-11-11 11:11:11',1);

/*Table structure for table `dynamic_upstream` */

DROP TABLE IF EXISTS `dynamic_upstream`;

CREATE TABLE `dynamic_upstream` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `dynamic_upstream` */

insert  into `dynamic_upstream`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{\"selectors\":[]}','meta','2019-04-16 18:31:26');

/*Table structure for table `headers` */

DROP TABLE IF EXISTS `headers`;

CREATE TABLE `headers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `headers` */

insert  into `headers`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{\"selectors\":[]}','meta','2019-04-16 18:31:34');

/*Table structure for table `hmac_auth` */

DROP TABLE IF EXISTS `hmac_auth`;

CREATE TABLE `hmac_auth` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `hmac_auth` */

insert  into `hmac_auth`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{}','meta','2016-11-11 11:11:11');

/*Table structure for table `key_auth` */

DROP TABLE IF EXISTS `key_auth`;

CREATE TABLE `key_auth` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `key_auth` */

insert  into `key_auth`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{}','meta','2016-11-11 11:11:11');

/*Table structure for table `meta` */

DROP TABLE IF EXISTS `meta`;

CREATE TABLE `meta` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(5000) NOT NULL DEFAULT '',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

/*Data for the table `meta` */

insert  into `meta`(`id`,`key`,`value`,`op_time`) values (7,'divide.enable','1','2019-04-09 23:02:16'),(15,'redirect.enable','0','2019-04-11 22:50:50'),(18,'node.enable','1','2019-04-13 22:55:55'),(19,'headers.enable','0','2019-04-15 10:55:09'),(20,'monitor.enable','0','2019-04-15 10:55:17'),(21,'property_rate_limiting.enable','0','2019-04-15 10:55:24'),(23,'persist.enable','0','2019-04-16 18:33:28'),(24,'dynamic_upstream.enable','0','2019-04-16 18:33:39'),(25,'balancer.enable','0','2019-04-16 18:33:43'),(26,'waf.enable','0','2019-04-16 18:33:51');

/*Table structure for table `monitor` */

DROP TABLE IF EXISTS `monitor`;

CREATE TABLE `monitor` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `monitor` */

insert  into `monitor`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{\"selectors\":[]}','meta','2019-04-16 18:31:44');

/*Table structure for table `node` */

DROP TABLE IF EXISTS `node`;

CREATE TABLE `node` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `node` */

insert  into `node`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{}','meta','2016-11-11 11:11:11');

/*Table structure for table `persist` */

DROP TABLE IF EXISTS `persist`;

CREATE TABLE `persist` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `persist` */

insert  into `persist`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{}','meta','2016-11-11 11:11:11');

/*Table structure for table `property_rate_limiting` */

DROP TABLE IF EXISTS `property_rate_limiting`;

CREATE TABLE `property_rate_limiting` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `property_rate_limiting` */

insert  into `property_rate_limiting`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{\"selectors\":[]}','meta','2019-04-16 18:32:38');

/*Table structure for table `rate_limiting` */

DROP TABLE IF EXISTS `rate_limiting`;

CREATE TABLE `rate_limiting` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `rate_limiting` */

insert  into `rate_limiting`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{\"selectors\":[]}','meta','2019-04-16 18:32:29');

/*Table structure for table `redirect` */

DROP TABLE IF EXISTS `redirect`;

CREATE TABLE `redirect` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `redirect` */

insert  into `redirect`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{\"selectors\":[]}','meta','2019-04-16 18:32:05');

/*Table structure for table `rewrite` */

DROP TABLE IF EXISTS `rewrite`;

CREATE TABLE `rewrite` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `rewrite` */

insert  into `rewrite`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{}','meta','2016-11-11 11:11:11');

/*Table structure for table `signature_auth` */

DROP TABLE IF EXISTS `signature_auth`;

CREATE TABLE `signature_auth` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `signature_auth` */

insert  into `signature_auth`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{}','meta','2016-11-11 11:11:11');

/*Table structure for table `waf` */

DROP TABLE IF EXISTS `waf`;

CREATE TABLE `waf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `waf` */

insert  into `waf`(`id`,`key`,`value`,`type`,`op_time`) values (1,'1','{\"selectors\":[]}','meta','2019-04-16 18:32:50');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

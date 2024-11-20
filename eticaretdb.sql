/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `eticaretdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci */;
USE `eticaretdb`;

DELIMITER //
CREATE PROCEDURE `addProductSP`(
	IN `p_urunAdi` VARCHAR(150),
	IN `p_fiyat` DECIMAL(9,2),
	IN `p_miktar` DECIMAL(9,2),
	IN `p_imageURL` VARCHAR(200)
)
BEGIN
    INSERT INTO tblproducts (urunAdi, fiyat, miktar, imageURL)
    VALUES (p_urunAdi, p_fiyat, p_miktar, p_imageURL);
    
    IF ROW_COUNT() > 0 THEN
    	SELECT JSON_OBJECT('isAdded', TRUE, 'message', 'Kayıt Eklenmiştir') AS result;
    ELSE
    	SELECT JSON_OBJECT('isAdded', FALSE, 'message', 'Kayıt Eklenirken Hata Oluştu') AS result;    
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `addUserSP`(
	IN `p_tcKimlikNo` CHAR(11),
	IN `p_password` VARCHAR(150)
)
BEGIN
	DECLARE userVarmi INT;
	DECLARE sonKayitNo INT;
	DECLARE sonuc VARCHAR(50);
	SET userVarmi = (SELECT COUNT(id) FROM tblperson WHERE tcKimlikNo=p_tcKimlikNo);
	IF (userVarmi = 0) THEN 
		INSERT INTO tblperson (tcKimlikNo, passwordSifre) 
			VALUES (p_tcKimlikNo, p_password);
		SET sonKayitNo = (SELECT max(id) FROM tblperson);
		SET sonuc= 'Kullanıcı Başarılı Şekilde Eklenmiştir';
	ELSEIF (userVarmi = 1) THEN 
		SET sonuc = 'Kullanıcı Kaydı Vardır.. Tekrar Eklenemez..';
	END IF;
	
	SELECT JSON_OBJECT('sonKayitNo', sonKayitNo, 'sonuc', sonuc) AS result;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `deleteProductByIdSP`(
	IN `p_id` INT
)
BEGIN
    DELETE FROM tblproducts WHERE id = p_id;
    IF ROW_COUNT() > 0 THEN
    	SELECT JSON_OBJECT('isDeleted', TRUE, 'message', 'Kayıt Silinmiştir') AS result;
    ELSE
    	SELECT JSON_OBJECT('isDeleted', FALSE, 'message', 'Kayıt Silinirken Hata Oluştu') AS result;    
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `getAllProductsSP`()
BEGIN
	SELECT json_arrayagg(
			JSON_OBJECT(
				'productID', id,
				'productName', urunAdi,
				'productPrice', fiyat,
				'productStock', miktar,
				'productPictureUrl', imageURL 
			)
			) AS result
		FROM tblproducts;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `getProductByIdSP`(
	IN `p_id` INT
)
BEGIN
	SELECT JSON_OBJECT(
				'productID', id,
				'productName', urunAdi,
				'productPrice', fiyat,
				'productStock', miktar,
				'productPictureUrl', imageURL
			) AS result
		FROM tblproducts WHERE id=p_id;
END//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `tblperson` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `adiSoyadi` varchar(75) DEFAULT NULL,
  `tcKimlikNo` char(11) DEFAULT NULL,
  `telefon` char(20) DEFAULT NULL,
  `fireStartDate` date DEFAULT NULL,
  `fireEndDate` date DEFAULT NULL,
  `aktifPasif` char(1) DEFAULT NULL,
  `statusID` int(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `passwordSifre` varchar(150) DEFAULT '$2a$10$NmwiZZoiKAkoPTrSSHslce5guInA9VlpBN7o6HiLytgwQunfGb2IS',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `tblperson` (`id`, `adiSoyadi`, `tcKimlikNo`, `telefon`, `fireStartDate`, `fireEndDate`, `aktifPasif`, `statusID`, `email`, `passwordSifre`) VALUES
	(1, 'ATEŞLEYİCİ AHMET', '12345678913', '+90 594 5552233', '2023-07-31', '2030-07-31', '1', 2, 'atesleyici@gmail.com', '$2a$10$NTbocMaBQh0cH.5g9egnwuj2tx4iWanvQwW9ghu9y338flnLggdMC'),
	(2, 'MÜHENDİS ZAFER', '12345678911', '+90 582 2224488', '2023-05-01', '2025-05-01', '1', 1, 'muhendis@gmail.com', '$2a$10$mo4zAy0IWU0Q3ctZ/VymhOQDFq6TrujADRBEy1Hsa0JzkRlQmHL3.'),
	(4, 'DEPOCU SERKAN', '12345678912', '2321111111', '2024-08-16', '2024-08-16', '1', 3, 'depocu@gmail.com', '$2a$10$nRiHjedQ4MONvGAmj7F6nOzc7VsQY6LUeZrVgkkM.p3Er2d4koXAS'),
	(5, 'Administrator', '12345678910', '+90 572 2224488', '2021-08-26', '2027-08-26', '1', 4, 'admin@gmail.com', '$2a$10$NTbocMaBQh0cH.5g9egnwuj2tx4iWanvQwW9ghu9y338flnLggdMC'),
	(6, 'ATEŞLEYİCİ DENEME', '12345678998', '500 001 00 00', '2024-03-15', '2027-03-15', '1', 2, 'yok@gmail.com', '$2a$10$O3iSGb7dNsd5xf/PmukBVegdoFTIlqZW3/OXLgUY33GL7.v623S2.'),
	(9, 'Admin', '13494080380', '500 001 00 00', NULL, NULL, '1', 4, 'yok@gmail.com', '$2a$10$FuHNic8ZF6I5jxbn9SPq5OeaGbhnA9dQwwNXODUodx.JJmLXAtLSW'),
	(10, 'ALİ VELİ KONYA', '12345678902', '+905325550044', '2024-09-15', '2025-07-14', '1', 3, 'alivekikonya@gmail.com', '$2a$10$xSssSjeRuo3JEMUq1D0O.OS6EFO9d0bs2TF7drpLWqbDGYsqKGJ/O'),
	(11, NULL, '12345678917', NULL, NULL, NULL, NULL, NULL, NULL, '$2a$14$fC/KRcM7nCD7LRETjClKuOkICfS2DkSXdK9FqYUChLOMtAxvED3la'),
	(12, NULL, '32165498710', NULL, NULL, NULL, NULL, NULL, NULL, '$2a$14$67dhEFwcJ41YvjlmUN9pz.k6VVRSeds0yUl9xgJIdPlhlDmu38BWO');

CREATE TABLE IF NOT EXISTS `tblproducts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `urunAdi` varchar(150) DEFAULT '0',
  `fiyat` decimal(9,2) DEFAULT NULL,
  `miktar` decimal(9,2) DEFAULT NULL,
  `imageURL` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

INSERT INTO `tblproducts` (`id`, `urunAdi`, `fiyat`, `miktar`, `imageURL`) VALUES
	(1, 'Laptop', 22500.00, 14.00, '/uploads/products/laptop.jpg'),
	(2, 'Drone', 14250.00, 8.00, '/uploads/products/drone.jpg'),
	(3, 'Erkek Ayakkabısı', 4300.00, 0.00, '/uploads/products/ayakkabi.jpg'),
	(4, 'Lenovo Gözlük', 33200.00, 11.00, '/uploads/products/lenovogozluk.jpg'),
	(19, 'Akvaryum', 15780.00, 4.00, '/uploads/products/1728583709_akvaryum.jpg');

DELIMITER //
CREATE PROCEDURE `updateProductByIdSP`(
    IN p_id INT,
    IN p_urunAdi VARCHAR(150),
    IN p_fiyat DECIMAL(9,2),
    IN p_miktar DECIMAL(9,2),
    IN p_imageURL VARCHAR(200)
)
BEGIN
    UPDATE tblproducts
    SET urunAdi = p_urunAdi,
        fiyat = p_fiyat,
        miktar = p_miktar,
        imageURL = p_imageURL
    WHERE id = p_id;

    IF ROW_COUNT() > 0 THEN
        SELECT JSON_OBJECT('isUpdated', TRUE, 'message', 'Ürün başarıyla güncellendi') AS result;
    ELSE
        SELECT JSON_OBJECT('isUpdated', FALSE, 'message', 'Ürün güncellenemedi') AS result;
    END IF;
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

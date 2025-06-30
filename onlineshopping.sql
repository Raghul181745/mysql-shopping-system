-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 30, 2025 at 08:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `onlineshopping`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `PlaceOrder` (IN `o_id` INT, IN `c_id` INT, IN `p_id1` INT, IN `qty1` INT, IN `p_id2` INT, IN `qty2` INT)   BEGIN
  DECLARE stock1 INT;
  DECLARE stock2 INT;
  DECLARE total DECIMAL(10,2);
  DECLARE price1 DECIMAL(10,2);
  DECLARE price2 DECIMAL(10,2);
  DECLARE od_id1 INT;
  DECLARE od_id2 INT;

  SELECT Stock_Quantity, Price INTO stock1, price1 FROM Product WHERE Product_ID = p_id1;
  SELECT Stock_Quantity, Price INTO stock2, price2 FROM Product WHERE Product_ID = p_id2;

  SET od_id1 = (SELECT IFNULL(MAX(OrderDetail_ID), 5000) + 1 FROM OrderDetails);
  SET od_id2 = od_id1 + 1;

  IF stock1 < qty1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock for Product 1';
  ELSEIF stock2 < qty2 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock for Product 2';
  ELSE
    SET total = (price1 * qty1) + (price2 * qty2);

    INSERT INTO Orders VALUES (o_id, c_id, CURDATE(), total);

    INSERT INTO OrderDetails VALUES 
      (od_id1, o_id, p_id1, qty1, price1 * qty1),
      (od_id2, o_id, p_id2, qty2, price2 * qty2);

    UPDATE Product SET Stock_Quantity = stock1 - qty1 WHERE Product_ID = p_id1;
    UPDATE Product SET Stock_Quantity = stock2 - qty2 WHERE Product_ID = p_id2;
  END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `Customer_ID` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Contact` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`Customer_ID`, `Name`, `Email`, `Contact`) VALUES
(101, 'John Doe', 'john@example.com', '9876543210'),
(102, 'Jane Smith', 'jane@example.com', '9123456789');

-- --------------------------------------------------------

--
-- Table structure for table `orderdetails`
--

CREATE TABLE `orderdetails` (
  `OrderDetail_ID` int(11) NOT NULL,
  `Order_ID` int(11) DEFAULT NULL,
  `Product_ID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Subtotal` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orderdetails`
--

INSERT INTO `orderdetails` (`OrderDetail_ID`, `Order_ID`, `Product_ID`, `Quantity`, `Subtotal`) VALUES
(5001, 1001, 1, 1, 50000.00),
(5002, 1001, 3, 1, 2000.00),
(5003, 1003, 1, 2, 100000.00),
(5004, 1003, 3, 2, 4000.00);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `Order_ID` int(11) NOT NULL,
  `Customer_ID` int(11) DEFAULT NULL,
  `Order_Date` date DEFAULT NULL,
  `Total_Amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`Order_ID`, `Customer_ID`, `Order_Date`, `Total_Amount`) VALUES
(1001, 101, '2025-06-30', 52000.00),
(1002, 102, '2025-06-30', 104000.00),
(1003, 102, '2025-06-30', 104000.00);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `Product_ID` int(11) NOT NULL,
  `Product_Name` varchar(50) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  `Stock_Quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`Product_ID`, `Product_Name`, `Price`, `Stock_Quantity`) VALUES
(1, 'Laptop', 50000.00, 7),
(2, 'Smartphone', 25000.00, 5),
(3, 'Headphones', 2000.00, 12);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`Customer_ID`);

--
-- Indexes for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`OrderDetail_ID`),
  ADD KEY `Order_ID` (`Order_ID`),
  ADD KEY `Product_ID` (`Product_ID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`Order_ID`),
  ADD KEY `Customer_ID` (`Customer_ID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`Product_ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`Order_ID`),
  ADD CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`Product_ID`) REFERENCES `product` (`Product_ID`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `customer` (`Customer_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

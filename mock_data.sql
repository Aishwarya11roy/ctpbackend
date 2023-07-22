CREATE DATABASE mock_data;

USE mock_data;

-- WordPress profiles table
CREATE TABLE wordpress_profiles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255),
  order_number VARCHAR(255),
  content TEXT,
  submitted TINYINT,
  published TINYINT,
  FOREIGN KEY (email, order_number) REFERENCES shopify_transactions(email, order_number)
);

-- Shopify transactions table
CREATE TABLE shopify_transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255),
  order_number VARCHAR(255),
  paid TINYINT,
  INDEX idx_shopify_transactions_email_order_number (email, order_number)
);

-- Mock data for wordpress_profiles table
INSERT INTO wordpress_profiles (email, order_number, content, submitted, published)
VALUES
  ('user1@example.com', 'ORD001', 'Profile content for user 1', 1, 1),
  ('user2@example.com', 'ORD002', 'Profile content for user 2', 1, 1),
  ('user3@example.com', 'ORD003', 'Profile content for user 3', 0, 0),
  ('user4@example.com', 'ORD004', 'Profile content for user 4', 1, 1),
  ('user5@example.com', 'ORD005', 'Profile content for user 5', 1, 0),
  ('user6@example.com', 'ORD006', 'Profile content for user 6', 1, 1),
  ('user7@example.com', 'ORD007', 'Profile content for user 7', 1, 0),
  ('user8@example.com', 'ORD008', 'Profile content for user 8', 1, 0),
  ('user9@example.com', 'ORD009', 'Profile content for user 9', 1, 1),
  ('user10@example.com', 'ORD010', 'Profile content for user 10', 0, 0);



-- Mock data for shopify_transactions table
INSERT INTO shopify_transactions (email, order_number, paid)
VALUES
  ('user1@example.com', 'ORD001', 1),
  ('user2@example.com', 'ORD002', 1),
  ('user3@example.com', 'ORD003', 0),
  ('user4@example.com', 'ORD004', 1),
  ('user5@example.com', 'ORD005', 0),
  ('user6@example.com', 'ORD006', 1),
  ('user7@example.com', 'ORD007', 0),
  ('user8@example.com', 'ORD008', 0),
  ('user9@example.com', 'ORD009', 1),
  ('user10@example.com', 'ORD010', 1);



select * from shopify_transactions;
select * from wordpress_profiles;

SELECT *
FROM shopify_transactions
WHERE email = 'user1@example.com' AND order_number = 'ORD001';

SELECT COUNT(*) AS pairing_exists
FROM shopify_transactions
WHERE email = 'user1@example.com' AND order_number = 'ORD001';

UPDATE wordpress_profiles
SET submitted = 1
WHERE id = 1;



-- Additional logic to manage profile publishing
DELIMITER $$
CREATE PROCEDURE ManageProfilePublishing(IN userEmail VARCHAR(255), IN userOrderNumber VARCHAR(255))
BEGIN
  DECLARE isSubmitted TINYINT;
  DECLARE isPaid TINYINT;
  
  -- Check if the profile is submitted
  SELECT submitted INTO isSubmitted
  FROM wordpress_profiles
  WHERE email = userEmail AND order_number = userOrderNumber;
  
  IF isSubmitted = 1 THEN
    -- Profile is submitted, check if the user has paid
    SELECT paid INTO isPaid
    FROM shopify_transactions
    WHERE email = userEmail AND order_number = userOrderNumber;
    
    IF isPaid = 1 THEN
      -- User has paid, update the published status
      UPDATE wordpress_profiles
      SET published = 1
      WHERE email = userEmail AND order_number = userOrderNumber;
      
      SELECT "Profile published successfully.";
    ELSE
      -- User has not paid, display a message to complete the payment
      SELECT "Please complete the payment to publish the profile.";
    END IF;
  ELSE
    -- Profile is not submitted, display a message to submit the profile
    SELECT "Please pay first.";
  END IF;
  
END$$
DELIMITER ;

-- Example usage of the ManageProfilePublishing procedure
CALL ManageProfilePublishing('user3@example.com', 'ORD003');

drop procedure ManageProfilePublishing;

<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s271304/foodtrack/php/PHPMailer/src/Exception.php';
require '/home8/crimsonw/public_html/s271304/foodtrack/php/PHPMailer/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s271304/foodtrack/php/PHPMailer/src/SMTP.php';

include_once("dbconnect.php");
$user_email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);
$rating = "0";
$credit = "0";
$status = "active";

$sqlregister = "INSERT INTO tbl_user(user_email,password,otp,rating,credit,status) VALUES('$user_email','$passha1','$otp','$rating','$credit','$status')";
if ($conn->query($sqlregister) === TRUE) {
    echo "success";
    sendEmail($otp,$user_email);
}
else{
    echo "failed";
}

function sendEmail($otp,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                       //Disable verbose debug output
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = 'mail.crimsonwebs.com';                 //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'foodtrack@crimsonwebs.com';            //SMTP username
    $mail->Password   = '}uyK8h9O%89I';                         //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "foodtrack@crimsonwebs.com";
    $to = $user_email;
    $subject = "From FoodTrack. Please Verify Your Account";
    $message = "<p>Click the following link to verify your account<br><br>
    <a href='https://crimsonwebs.com/s271304/foodtrack/php/verify_account.php?email=".$user_email."&key=".$otp."'>Click Here to verify your account</a>";
    
    $mail->setFrom($from,"FoodTrack");
    $mail->addAddress($to);     
    
    $mail->isHTML(true);                    //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
    
}
?>
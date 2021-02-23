
## Fygo Assessment
Using Flutter and the following design, create a custom password field widget that indicates the strength of the password as the user types.

  
![](https://lh5.googleusercontent.com/ngbo1YWaQp7BOqdYu9S-UFJP4QgRP1jDkR6aXPNMqdRGTP_Y2IXaQ4wK1laYrM5Y2bkWnBzcipEJBw0Ljw7NKV-5lpBfCGsFg51QAm8fu934F15bsF5Hi9SErWAQREcozehCzTo1Cq5IBPiJFw)

  

For the purposes of this assignment, if the length of the password is less than 4, it is weak. If it is less than 7 characters, it is medium. If it is 7 characters or longer then it is a strong password. The coloured bar and “Strong password” text should change as the password strength changes.

  

Create a simple Android and iOS app to demonstrate its functionality. Explain your approach and the decisions you took.
  

## Getting Started
To run the project please make sure you are using the following flutter version:
 - Flutter (Channel beta, 1.26.0-17.6.pre)
 - This project uses Sound Null Safety feature


## Description

To implement the required password text field, I have decided to create the component using a Statefull Widget. The component is contained and simple enough to only require local state. 

The **StrengthField** widget has 3 parameters: **label**, **controller** (optional) and **onChanged**.

For the given design, a **Column** with 3 components would have sufficed. Instead, I went with another approach which allowed for a more animated, but subtle experience.

A **Stack** has been used, made out of the 3 components: the animated label, a simple text field and a column containing the label showing how strong the password is label and an animated container for the line. 

The text field has a focus nodes, which helps in determining when the text field has focus or not and trigger the moving animation for the label.

The private enum **_PasswordState** containing (empty, weak, medium, strong) - is used to determine how the widgets will be customised. When the text field's onChange is triggered then it is determined how strong the password is based on it's length and the appropriate state is changed. Based on this, the gradient colours of the line, label colour, and label are changed accordingly. The suffix icon of the text field is also displayed only when the password is strong.

Tests have been made for the component as well and can be found in **/test/components/strength_password_field_test.dart**.


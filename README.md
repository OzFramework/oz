# Oz

Oz is a behavioral web-ui testing framework developed to reduce test maintenance by using a predictive model rather
than a scriptive model when writing tests.

## The two primary goals of Oz:
#### Keep test maintenance to a minimum
- When it comes to automated testing, maintenance is the #1 enemy. This is such an important point that it is worth
repeating just in case you missed it: MAINTENANCE IS THE ENEMY! While it is true that we will never be able to eliminate
test maintenance entirely, what determines success or failure within a testing effort is _how much_ maintenance we have
to perform on a regular basis. To combat maintenance Oz uses predictive modelling to determine validation rather than
static scripted tests.

#### Keep the framework extensible and modular
- After automating various applications one thing becomes very clear; There is no such thing as a 'perfect solution'.
No two applications function exactly the same all the time and this is _especially_ true of web applications.
Therefore trying to write one framework that will always handle everything that could possibly happen is basically impossible.
So how do we combat this? There has to be a solution right? The answer is to have a framework that does the basics
_really well_ and allow for users to take advantage of extensibility and overriding to handle the edge cases that they will face.



## Simple setup instructions:

1) To run the examples you need two gems:

    `gem install cucumber`

    `gem install watir-webdriver`

2) To run the examples there are two steps:

    `cd EXAMPLE/`

    `cucumber -p example`



intro

goals

documentation links

installation

running the examples

AUT setup6

FAQ
 - I want to help out with Oz, what can I do?
    - check out the issues and pick up a card marked as `help wanted`
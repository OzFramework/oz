# Oz

Oz is a behavioral web-ui testing framework developed to reduce test maintenance by using a predictive model rather
than a scriptive model when writing tests. Oz is designed with extensibility and customization in mind but allows you
to move past the basics of designing a framework quickly and easily.

## The two primary goals of Oz:
#### Keep test maintenance to a minimum
When it comes to automated testing, maintenance is the #1 enemy. This is such an important point that it is worth
repeating just in case you missed it: MAINTENANCE IS THE ENEMY! While it is true that we will never be able to eliminate
test maintenance entirely, what determines success or failure within a testing effort is _how much_ maintenance we have
to perform on a regular basis.

To combat maintenance Oz uses predictive modelling to determine validation rather than
static scripted tests. More information on what we mean by predictive modelling vs scripted modelling (and how Oz manages this)
can check out our page on [Predictive vs Scripted testing](https://github.com/greenarrowdb/oz/wiki/Predictive-vs-Scripted-testing).

#### Keep the framework extensible and modular
  After automating various applications one thing becomes very clear: There is no such thing as a 'perfect solution'.
No two applications function exactly the same all the time and this is _especially_ true of web applications.
Therefore trying to write one framework that will always handle everything that could possibly happen is basically impossible.

  So how do we combat this? There has to be a solution right? The answer is to have a framework that does the basics
_really well_ and allow for users to take advantage of extensibility and overriding to handle the edge cases that they will face.
Oz has been designed with this style of extensibility in mind. Our hope is that Oz will give you the tooling you need to
handle 90% of your problem, and be flexible enough to allow you to come up with the last 10% very easily.

## Documentation

Usage and functional documentation can be found on the [Oz Wiki](https://github.com/greenarrowdb/oz/wiki)



## Installation instructions:

To run Oz and its example tests you will need to have two gems installed beforehand:

    gem install cucumber
    gem install watir

To run the examples included there are two steps:

    cd EXAMPLE/
    cucumber -p example


## Quick Guide for setting up your application

To setup a test suite for your application using Oz we have created a [quick guide](https://github.com/greenarrowdb/oz/wiki/Setup-Quick-Guide)


## Contributing and Questions

If you have a feature you would like to see included in the Oz CORE set of features you can submit a pull request
following [these guidelines](https://github.com/greenarrowdb/oz/blob/master/CONTRIBUTING.md).

If you have questions, feedback, or would just like to chat about testing with the maintainers you can
check out the [Oz discord channel](https://discord.gg/yjKsWS6)

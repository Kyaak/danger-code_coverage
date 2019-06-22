<h1 align="center">danger-code_coverage</h1>

<div align="center">
  <!-- Sonar Cloud -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
    <img src="https://sonarcloud.io/images/project_badges/sonarcloud-white.svg"
      alt="Sonar Cloud" />
  </a>
</div>

</br>

<div align="center">
  <!-- Version -->
  <a href="https://badge.fury.io/rb/danger-code_coverage">
    <img src="https://badge.fury.io/rb/danger-code_coverage.svg" alt="Version" />
  </a>
  <!-- Downloads -->
  <a href="https://badge.fury.io/rb/danger-code_coverage">
    <img src="https://img.shields.io/gem/dt/danger-code_coverage.svg" alt="Downloads" />
  </a>
</div>

<div align="center">
  <!-- Build Status -->
  <a href="https://travis-ci.org/Kyaak/danger-code_coverage">
    <img src="https://img.shields.io/travis/choojs/choo/develop.svg"
      alt="Build Status" />
  </a>
  <!-- Coverage -->
    <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
      <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-code_coverage&metric=coverage"
        alt="Coverage" />
    </a>
</div>

<div align="center">
  <!-- Reliability Rating -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-code_coverage&metric=reliability_rating"
      alt="Reliability Rating" />
  </a>
  <!-- Security Rating -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-code_coverage&metric=security_rating"
      alt="Security Rating" />
  </a>
  <!-- Maintainabiltiy -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-code_coverage&metric=sqale_rating"
      alt="Maintainabiltiy" />
  </a>
</div>

<div align="center">
  <!-- Code Smells -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-code_coverage&metric=code_smells"
      alt="Code Smells" />
  </a>
  <!-- Bugs -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-code_coverage&metric=bugs"
      alt="Bugs" />
  </a>
  <!-- Vulnerabilities -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-code_coverage&metric=vulnerabilities"
      alt="Vulnerabilities" />
  </a>
  <!-- Technical Dept -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-code_coverage">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-code_coverage&metric=sqale_index"
      alt="Technical Dept" />
  </a>
</div>
</br>

This [danger](https://github.com/danger/danger) plugin generates a coverage overview for modified files :100: <br>

This plugin is inspired and works only with the jenkins [code-coverage-api-plugin](https://github.com/jenkinsci/code-coverage-api-plugin) :bowing_man:

## How it looks like

### Code Coverage :100:

|**File**|**Total**|**Method**|**Line**|**Conditional**|**Instruction**|
|:-|:-:|:-:|:-:|:-:|:-:|
|com/example/kyaak/myapplication/MyUtil.java|50.94|13.34|75.0|49.99|65.44|
|com/example/kyaak/myapplication/MyController.java|19.94|13.34|30.0|20.99|15.44|
|com/example/kyaak/myapplication/MainActivity.java|0.0|0.0|0.0|0.0|0.0|

## Installation

    $ gem install danger-code_coverage

## Usage

    code_coverage.report

## Authentication

If you run a jenkins server with required authentication you can pass them to `danger-code_coverage`.
Create an API token with your CI user and do not pass normal password credentials.

    code_coverage.report(
        auth_user: "jenkins",
        auth_token: "MY_TOKEN"
    )

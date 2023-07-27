class OldairyLocale {
  String hours = '';
  String minutes = '';
  String initialTemp = '';
  String setTemp = '';
  String volume = '';
  String voltage = '';
  String ampFirstWire = '';
  String ampSecondWire = '';
  String ampThirdWire = '';
  String clearAll = '';
  String settings = '';
  String about = '';
  String help = '';
  String exit = '';
  String general = '';
  String language = '';
  String oldStandardSupport = '';
  String defaults = '';
  String apply = '';

  OldairyLocale({
    hours = '',
    minutes = '',
    initialTemp = '',
    setTemp = '',
    volume = '',
    voltage = '',
    ampFirstWire = '',
    ampSecondWire = '',
    ampThirdWire = '',
    clearAll = '',
    settings = '',
    about = '',
    help = '',
    exit = '',
    general = '',
    language = '',
    oldStandardSupport = '',
    defaults = '',
    apply = '',
  });
}

/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OldairyLocale {
  String _hours = '';
  String _minutes = '';
  String _initialTemp = '';
  String _setTemp = '';
  String _volume = '';
  String _voltage = '';
  String _ampFirstWire = '';
  String _ampSecondWire = '';
  String _ampThirdWire = '';
  String _clearAll = '';
  String _settings = '';
  String _about = '';
  String _help = '';
  String _exit = '';
  String _general = '';
  String _language = '';
  String _oldStandardSupport = '';
  String _defaults = '';
  String _apply = '';

  Future<void> readDefaultLocale() async {
    final String response =
        await rootBundle.loadString('assets/locales/en_us.json');
    final data = await json.decode(response);
    Map<String, dynamic> locale = data;

    _hours = locale['hours'];
    _minutes = locale['minutes'];
    _initialTemp = locale['initialTemp'];
    _setTemp = locale['setTemp'];
    _volume = locale['volume'];
    _voltage = locale['voltage'];
    _ampFirstWire = locale['ampFirst'];
    _ampSecondWire = locale['ampSecond'];
    _ampThirdWire = locale['ampThird'];
    _clearAll = locale['clearAll'];
    _settings = locale['settings'];
    _about = locale['about'];
    _help = locale['help'];
    _exit = locale['exit'];
    _general = locale['general'];
    _language = locale['language'];
    _oldStandardSupport = locale['oldStandard'];
    _defaults = locale['defaults'];
    _apply = locale['apply'];
  }

  String getHours() {
    return _hours;
  }

  String getMinutes() {
    return _minutes;
  }

  String getInitialTemp() {
    return _initialTemp;
  }

  String getSetTemp() {
    return _setTemp;
  }

  String getVolume() {
    return _volume;
  }

  String getVoltage() {
    return _voltage;
  }

  String getAmpFirst() {
    return _ampFirstWire;
  }

  String getAmpSecond() {
    return _ampSecondWire;
  }

  String getAmpThird() {
    return _ampThirdWire;
  }

  String getClearAll() {
    return _clearAll;
  }

  String getSettings() {
    return _settings;
  }

  String getAbout() {
    return _about;
  }

  String getHelp() {
    return _help;
  }

  String getExit() {
    return _exit;
  }

  String getGeneral() {
    return _general;
  }

  String getLanguage() {
    return _language;
  }

  String getOldStandard() {
    return _oldStandardSupport;
  }

  String getDefaults() {
    return _defaults;
  }

  String getApply() {
    return _apply;
  }
}*/

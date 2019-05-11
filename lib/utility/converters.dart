class Converters {
  static String convertKelvinToCelcius(String tempK) {
    double tempKdouble = double.parse(tempK);
    double tempC = tempKdouble - 273.15;
    return tempC.round().toString();
  }

  static String getWeatherIcon(String icon) {
    switch (icon) {
      case "01d":
        return "clear-day";
        break;
      case "01n":
        return "clear-night";
        break;
      case "02d":
        return "partly-cloudy-day";
        break;
      case "02n":
        return "partly-cloudy-night";
        break;
      case "03d":
        return "mostly-cloudy-day";
        break;
      case "03n":
        return "mostly-cloudy-night";
        break;
      case "04d":
      case "04n":
        return "cloudy";
        break;
      case "09d":
      case "09n":
        return "rainy-weather";
        break;
      case "10d":
        return "rainy-day";
        break;
      case "10n":
        return "rainy-night";
        break;
      case "11d":
        return "thunder-day";
        break;
      case "11n":
        return "thunder-night";
        break;
      case "50d":
        return "haze-weather";
        break;
      case "11n":
        return "thunder-night";
        break;
      case "11n":
        return "thunder-night";
        break;
      default:
        return "unknown";
    }
  }
}

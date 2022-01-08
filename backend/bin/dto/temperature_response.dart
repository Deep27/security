class TemperatureResponse {
  final int thermalZone;
  final int temperature;

  TemperatureResponse(this.thermalZone, this.temperature);

  Map<String, dynamic> toJson() {
    return {
      'thermalZone': thermalZone,
      'temperature': temperature,
    };
  }
}

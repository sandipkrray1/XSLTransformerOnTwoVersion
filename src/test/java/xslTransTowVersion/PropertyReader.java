package xslTransTowVersion;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertyReader {
	public Properties properties = new Properties();
	InputStream inputStreamConfig = null;

	public PropertyReader() {
		String filePath = System.getProperty("user.dir") + "/src/test/resources/propertyFiles//config.properties";
		loadProperties(filePath);
	}

	private void loadProperties(String filePath) {
		try {
			inputStreamConfig = new FileInputStream(filePath);
			properties.load(inputStreamConfig);

		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public String readProperty(String key) {
		return properties.getProperty(key);
	}
	public void setProperty(String key, String value) {
		properties.setProperty(key, value);
	}
}

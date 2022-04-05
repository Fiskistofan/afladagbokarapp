/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Stokkur Software ehf.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package is.stokkur.afladagbok.android.utils;

/**
 * Created by annalaufey on 12/21/17.
 */

public final class LogUtils {

    private LogUtils() {

    }

    //TODO add fabric

    /*
    public static void logScreen(String screen) {
        logEvent(screen, null);
    }

    public static void logError(String name, Map<String, String> extras) {
        logEvent("Error: " + name, extras);
    }

    public static void logPurchase(Map<String, String> extras) {
        logEvent("Purchase", extras);
    }

    private static void logEvent(String name, Map<String, String> extras) {
        CustomEvent event = new CustomEvent(name);
        if (extras != null) {
            for (Map.Entry<String, String> entry : extras.entrySet()) {
                event.putCustomAttribute(entry.getKey(), entry.getValue());
            }
        }
        Answers.getInstance().logCustom(event);
    }**/

}
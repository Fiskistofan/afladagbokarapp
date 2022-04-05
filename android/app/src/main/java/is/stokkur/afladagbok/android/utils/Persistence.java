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

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by annalaufey on 1/3/18.
 */

public final class Persistence {

    private static final String SHARED_PREFS_NAME = "is.stokkur.afladagbok.android.utils.Persistence";
    public static final String KEY_IS_ACTIVE_TRIP = SHARED_PREFS_NAME + ".KEY_IS_ACTIVE_TRIP";
    public static final String KEY_CURRENT_ACTIVE_TRIP = SHARED_PREFS_NAME + ".KEY_CURRENT_ACTIVE_TRIP";
    public static final String KEY_PROFILE = SHARED_PREFS_NAME + ".KEY_PROFILE";
    public static final String KEY_ONBOARDING_FLAG = SHARED_PREFS_NAME + ".KEY_ONBOARDING";
    public static final String KEY_CURRENT_BOAT_ID = SHARED_PREFS_NAME + ".KEY_CURRENT_BOAT_ID";

    public static final String KEY_RECENT_PORTS = SHARED_PREFS_NAME + ".KEY_RECENT_PORTS";
    public static final String KEY_RECENT_FISH = SHARED_PREFS_NAME + ".KEY_RECENT_FISH";
    public static final String KEY_RECENT_MAMMALS_AND_BIRDS = SHARED_PREFS_NAME + ".KEY_RECENT_MAMMALS_AND_BIRDS";

    private static SharedPreferences sSharedPreferences = null;

    private Persistence() {

    }

    public static void init(Context context) {
        if (sSharedPreferences == null) {
            context = context.getApplicationContext();
            sSharedPreferences = context.getSharedPreferences(SHARED_PREFS_NAME,
                    Context.MODE_PRIVATE);
        }
    }

    public static void clear() {
        SharedPreferences.Editor edit = sSharedPreferences.edit();
        edit.clear();
        edit.apply();
    }

    public static String getStringValue(String key) {
        return sSharedPreferences.getString(key, null);
    }

    public static boolean getBooleanValue(String key) {
        return sSharedPreferences.getBoolean(key, false);
    }

    public static int getIntValue(String key) {
        return sSharedPreferences.getInt(key, 0);
    }

    public static void saveStringValue(String key, String value) {
        SharedPreferences.Editor editor = sSharedPreferences.edit();
        editor.putString(key, value);
        editor.apply();
    }

    public static void saveBooleanValue(String key, boolean value) {
        SharedPreferences.Editor editor = sSharedPreferences.edit();
        editor.putBoolean(key, value);
        editor.apply();
    }

    public static void saveIntValue(String key, int value) {
        SharedPreferences.Editor editor = sSharedPreferences.edit();
        editor.putInt(key, value);
        editor.apply();
    }
}

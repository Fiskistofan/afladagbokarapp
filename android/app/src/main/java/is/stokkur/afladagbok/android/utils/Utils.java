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

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.Locale;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.models.Equipment;
import is.stokkur.afladagbok.android.models.FishAndAnimalCatch;
import is.stokkur.afladagbok.android.models.FishingEquipments;
import is.stokkur.afladagbok.android.models.ProfileResponse;
import is.stokkur.afladagbok.android.models.StartTourResponse;

import static android.content.Context.INPUT_METHOD_SERVICE;
import static is.stokkur.afladagbok.android.AfladagbokApplication.getAppContext;

/**
 * Created by annalaufey on 11/8/17.
 */

public class Utils {


    private static Locale is_locale = new Locale("is");
    private static SimpleDateFormat stringDateFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", is_locale);
    public static Comparator<FishAndAnimalCatch> dateComparator = (catch1, catch2) -> {
        int fomattedDate = 0;
        try {
            fomattedDate = stringDateFormatter.parse(catch1.getRegistryDate()).compareTo(stringDateFormatter.parse(catch2.getRegistryDate()));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return fomattedDate;
    };

    /**
     * @return Today's date in the format 2018-2-10
     */
    public static String getYearMontDay(int day, int month, int year) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, day);
        SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd", new Locale("is"));
        return date.format(calendar.getTime());
    }

    /**
     * @return Today's date in the format 10th February 2017
     */
    public static String getDayAndYearFormatted() {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat date = new SimpleDateFormat("d. LLLL yyyy", new Locale("is"));
        String today = date.format(cal.getTime());
        return today;
    }

    /**
     * @param day
     * @param month
     * @param year
     * @return Given date in format 14 des. 2017
     */
    public static String getSelectedDayAndYearFormatted(int day, int month, int year) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, day);
        SimpleDateFormat date = new SimpleDateFormat("dd MMM yyyy", new Locale("is"));
        return date.format(calendar.getTime());
    }

    /**
     * @param date
     * @return Given date in format 14 des. 2017
     */
    public static String getFormattedStringFromDate(String date) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        try {
            calendar.setTime(format.parse(date));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd MMM yyyy", is_locale);
        return simpleDateFormat.format(calendar.getTime());
    }

    static public String formatToDayMonthYearHourMinutes(String date) {
        SimpleDateFormat parser = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", is_locale);
        Calendar calendar = Calendar.getInstance();
        try {
            calendar.setTime(parser.parse(date));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy HH:mm", is_locale);
        return formatter.format(calendar.getTime());
    }

    /**
     * Sets date for registering toss and pull
     *
     * @return 2018-01-23T08:33:10
     */
    public static String getRegistryTodayDate() {
        Calendar calendar = Calendar.getInstance();
        String date = stringDateFormatter.format(calendar.getTime());
        return date;
    }

    public static String getTime(String date) {
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        Date newDate = new Date();
        try {
            newDate = stringDateFormatter.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return timeFormat.format(newDate);
    }

    /**
     * Hides soft keyboard
     *
     * @param activity
     */
    public static void hideSoftKeyboard(Activity activity) {
        InputMethodManager manager = (InputMethodManager) activity.
                getSystemService(INPUT_METHOD_SERVICE);
        if (manager != null) {
            View currentFocus = activity.getCurrentFocus();
            if (currentFocus != null) {
                manager.hideSoftInputFromWindow(currentFocus.getWindowToken(), 0);
            }
        }
    }

    /**
     * Shows soft keyboard
     *
     * @param activity
     * @param editText
     */
    public static void showSoftKeyboard(Activity activity, EditText editText) {
        InputMethodManager manager = (InputMethodManager) activity.
                getSystemService(INPUT_METHOD_SERVICE);
        if (manager != null) {
            manager.showSoftInput(editText, InputMethodManager.SHOW_IMPLICIT);
        }
    }

    /**
     * Checks network connection
     *
     * @return
     */
    public static boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) getAppContext().getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = null;
        if (connectivityManager != null) {
            activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        }
        return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    }

    /**
     * Returns the current active tour id
     *
     * @return
     */
    public static int getCurrentTourId() {
        int tourId = 0;
        StartTourResponse startTourObject = GsonInstance.sInstance.fromJson(Persistence.getStringValue(Persistence.KEY_CURRENT_ACTIVE_TRIP), StartTourResponse.class);
        if (startTourObject != null && startTourObject.getTour() != null) {
            tourId = startTourObject.getTour().getTourId();
        }
        return tourId;
    }

    public static String getShortNameForType(Context context, String type) {
        if (type != null) {
            if (type.compareTo(FishingEquipments.HAND) == 0) {
                return context.getString(R.string.hand);
            } else if (type.compareTo(FishingEquipments.LINE) == 0) {
                return context.getString(R.string.line);
            } else if (type.compareTo(FishingEquipments.NET) == 0) {
                return context.getString(R.string.net);
            }
        }
        return null;
    }

    public static int getIconForType(String type) {
        if (type != null) {
            if (type.compareTo(FishingEquipments.HAND) == 0) {
                return R.drawable.ic_hook_new;
            } else if (type.compareTo(FishingEquipments.LINE) == 0) {
                return R.drawable.ic_line_new;
            } else if (type.compareTo(FishingEquipments.NET) == 0) {
                return R.drawable.ic_net_new;
            }
        }
        return 0;
    }

    public static int getIconForType(int typeId) {
        String type = getTypeForTypeId(typeId);
        if (type.compareTo(FishingEquipments.HAND) == 0) {
            return R.drawable.ic_hook_new;
        } else if (type.compareTo(FishingEquipments.LINE) == 0) {
            return R.drawable.ic_line_new;
        } else if (type.compareTo(FishingEquipments.NET) == 0) {
            return R.drawable.ic_net_new;
        }
        return 0;
    }

    public static String getTypeForTypeId(int typeId) {
        String jsonProfile = Persistence.getStringValue(Persistence.KEY_PROFILE);
        ProfileResponse profile = GsonInstance.sInstance.fromJson(jsonProfile, ProfileResponse.class);
        ArrayList<FishingEquipments> types = profile.getFishingEquipments();
        int size = types != null ? types.size() : 0;
        if (size > 0) {
            FishingEquipments equipment;
            for (int i = 0; i < size; ++i) {
                equipment = types.get(i);
                if (equipment.getId() == typeId) {
                    return equipment.getType();
                }
            }
        }
        return "";
    }

    public static String getTourType() {
        String json = Persistence.getStringValue(Persistence.KEY_CURRENT_ACTIVE_TRIP);
        StartTourResponse tour = GsonInstance.sInstance.fromJson(json, StartTourResponse.class);
        Equipment tourFishingEquipment = tour.getFishingEquipment();

        String jsonProfile = Persistence.getStringValue(Persistence.KEY_PROFILE);
        ProfileResponse profile = GsonInstance.sInstance.fromJson(jsonProfile, ProfileResponse.class);
        ArrayList<FishingEquipments> types = profile.getFishingEquipments();
        int size = types != null ? types.size() : 0;
        if (size > 0) {
            FishingEquipments equipment;
            for (int i = 0; i < size; ++i) {
                equipment = types.get(i);
                if (equipment.getId() == tourFishingEquipment.getFishingEquipmentTypeId()) {
                    return equipment.getType();
                }
            }
        }
        return "";
    }

    public static String getTossType(StoredToss toss) {
        String jsonProfile = Persistence.getStringValue(Persistence.KEY_PROFILE);
        ProfileResponse profile = GsonInstance.sInstance.fromJson(jsonProfile, ProfileResponse.class);
        ArrayList<FishingEquipments> types = profile.getFishingEquipments();
        int size = types != null ? types.size() : 0;
        if (size > 0) {
            FishingEquipments equipment;
            for (int i = 0; i < size; ++i) {
                equipment = types.get(i);
                if (equipment.getId() == toss.getEquipmentTypeId()) {
                    return equipment.getType();
                }
            }
        }
        return "";
    }

    public static String getTossTypeName(StoredToss toss) {
        String jsonProfile = Persistence.getStringValue(Persistence.KEY_PROFILE);
        ProfileResponse profile = GsonInstance.sInstance.fromJson(jsonProfile, ProfileResponse.class);
        ArrayList<FishingEquipments> types = profile.getFishingEquipments();
        int size = types != null ? types.size() : 0;
        if (size > 0) {
            FishingEquipments equipment;
            for (int i = 0; i < size; ++i) {
                equipment = types.get(i);
                if (equipment.getId() == toss.getEquipmentTypeId()) {
                    return equipment.getName();
                }
            }
        }
        return "";
    }

}

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

package is.stokkur.afladagbok.android.extensions;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;

import java.util.List;

public class ActivityExtensions {

    private ActivityExtensions() {

    }

    public static boolean isInValidState(Activity activity) {
        return activity.isFinishing() || activity.isDestroyed();

    }

    public static void openWebLink(Context context,
                                   String link,
                                   Runnable onError) {
        openWebLink(context, link, false, null, onError);
    }

    public static void openWebLink(Context context,
                                   String link,
                                   boolean showChooser,
                                   String chooserTitle,
                                   Runnable onError) {
        Uri uri = Uri.parse(link);
        Intent intent = new Intent(Intent.ACTION_VIEW, uri);
        PackageManager manager = context.getPackageManager();
        List<ResolveInfo> resolvedActivities = manager.
                queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
        if (resolvedActivities.size() > 0) {
            if (showChooser) {
                intent = Intent.createChooser(intent, chooserTitle);
            }
            context.startActivity(intent);
        } else {
            onError.run();
        }
    }

    public static void showInfoDialog(Context context,
                                      String title,
                                      String message,
                                      String action) {
        new AlertDialog.Builder(context).
                setTitle(title).
                setMessage(message).
                setPositiveButton(action, (dialog, which) -> dialog.dismiss()).
                create().
                show();
    }

}

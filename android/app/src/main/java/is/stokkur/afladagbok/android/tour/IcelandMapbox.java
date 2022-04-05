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

package is.stokkur.afladagbok.android.tour;

import android.app.Activity;
import android.util.Log;

import com.mapbox.mapboxsdk.geometry.LatLngBounds;
import com.mapbox.mapboxsdk.offline.OfflineManager;
import com.mapbox.mapboxsdk.offline.OfflineRegion;
import com.mapbox.mapboxsdk.offline.OfflineRegionDefinition;
import com.mapbox.mapboxsdk.offline.OfflineRegionError;
import com.mapbox.mapboxsdk.offline.OfflineRegionStatus;
import com.mapbox.mapboxsdk.offline.OfflineTilePyramidRegionDefinition;

import org.json.JSONObject;

import is.stokkur.afladagbok.android.R;

/**
 * Class that handles the logic to download an area which right now is Iceland, this class can be
 * easily generalized by just accepting as parameters the coordinates, zoom levels and region name
 * and just replace them where a reference to the constants is been used.
 */
public class IcelandMapbox {

    public static final double sWest = -25.34733163552096;
    public static final double sNorth = 66.81631216196988;
    public static final double sEast = -12.609459631363052;
    public static final double sSouth = 63.0544669945173;
    public static final double sMinZoom = 6;
    public static final double sMaxZoom = 11;

    private static final String REGION_NAME = "Iceland";
    private static final String JSON_CHARSET = "UTF-8";
    private static final String JSON_FIELD_REGION_NAME = "FIELD_REGION_NAME";

    private final Activity mActivity;
    private final OfflineManager mOfflineManager;
    private final String mStyleUrl;

    private final DownloadProgressListener mListener;

    public IcelandMapbox(TourFragment fragment, DownloadProgressListener listener) {
        mListener = listener;
        Activity activity = fragment.getActivity();
        mActivity = activity;
        mOfflineManager = OfflineManager.getInstance(activity);
        mStyleUrl = activity.getString(R.string.mapbox_style_url);
    }

    /**
     * Start the area download process.
     */
    public void download() {
        mListener.onStart();
        mOfflineManager.listOfflineRegions(new OfflineManager.ListOfflineRegionsCallback() {
            @Override
            public void onList(OfflineRegion[] offlineRegions) {
                processRegions(offlineRegions);
            }

            @Override
            public void onError(String error) {
                mListener.onComplete(false, error);
            }
        });
    }

    /**
     * Check if we have already downloaded a region that is equal to what we want, maybe later we
     * can change to use contains instead of values comparison?
     *
     * @param offlineRegions A list of OfflineRegion to search againts.
     */
    private void processRegions(OfflineRegion[] offlineRegions) {
        int length = offlineRegions.length;
        if (length > 0) {
            LatLngBounds bounds;
            OfflineRegionDefinition definition;
            OfflineTilePyramidRegionDefinition pyramidRegion;
            for (int i = 0; i < length; ++i) {
                final OfflineRegion offlineRegion = offlineRegions[i];
                definition = offlineRegion.getDefinition();
                bounds = definition.getBounds();
                try {
                    pyramidRegion = (OfflineTilePyramidRegionDefinition) definition;
                } catch (Exception ex) {
                    pyramidRegion = null;
                }

                if (bounds.getLonWest() == sWest && bounds.getLatNorth() == sNorth &&
                        bounds.getLonEast() == sEast && bounds.getLatSouth() == sSouth &&
                        pyramidRegion != null && pyramidRegion.getMinZoom() == sMinZoom &&
                        pyramidRegion.getMaxZoom() == sMaxZoom) {
                    offlineRegion.getStatus(new OfflineRegion.OfflineRegionStatusCallback() {
                        @Override
                        public void onStatus(OfflineRegionStatus status) {
                            if (status.isComplete()) {
                                mListener.onComplete(true, null);
                            } else {
                                requestDownload(offlineRegion);
                            }
                        }

                        @Override
                        public void onError(String error) {
                            mListener.onComplete(false, error);
                        }
                    });
                    return;
                }
            }
        }
        createRegion();
    }

    /**
     * Create an offline region and register it.
     */
    private void createRegion() {
        float ratio = mActivity.getResources().getDisplayMetrics().density;
        OfflineTilePyramidRegionDefinition region = new OfflineTilePyramidRegionDefinition(
                mStyleUrl, LatLngBounds.from(sNorth, sEast, sSouth, sWest), sMinZoom, sMaxZoom,
                ratio);

        byte[] metadata;
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put(JSON_FIELD_REGION_NAME, REGION_NAME);
            String json = jsonObject.toString();
            metadata = json.getBytes(JSON_CHARSET);
        } catch (Exception ex) {
            Log.d("Create region", mActivity.getString(R.string.offline_map_error));
            return;
        }

        mOfflineManager.createOfflineRegion(region, metadata,
                new OfflineManager.CreateOfflineRegionCallback() {
                    @Override
                    public void onCreate(OfflineRegion offlineRegion) {
                        requestDownload(offlineRegion);
                    }

                    @Override
                    public void onError(String error) {
                        mListener.onComplete(false, error);
                    }
                });
    }

    /**
     * Request to download an offline region.
     *
     * @param offlineRegion The region to download.
     */
    private void requestDownload(OfflineRegion offlineRegion) {
        offlineRegion.setObserver(new OfflineRegion.OfflineRegionObserver() {
            @Override
            public void onStatusChanged(OfflineRegionStatus status) {
                if (status.isComplete()) {
                    mListener.onComplete(true, null);
                } else {
                    double resourceCount = status.getCompletedResourceCount();
                    double requiredResourceCount = status.getRequiredResourceCount();
                    double percentage = resourceCount / requiredResourceCount;
                    mListener.onProgress(percentage);
                }
            }

            @Override
            public void onError(OfflineRegionError error) {
                mListener.onComplete(false, error.getMessage());
            }

            @Override
            public void mapboxTileCountLimitExceeded(long limit) {
                Log.d("Request download", mActivity.getString(R.string.offline_map_error));
            }
        });
        offlineRegion.setDownloadState(OfflineRegion.STATE_ACTIVE);
    }

    public interface DownloadProgressListener {

        void onStart();

        void onProgress(double progress);

        void onComplete(boolean success, String message);

    }

}

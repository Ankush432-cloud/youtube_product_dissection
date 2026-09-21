-- ============================================
-- YouTube Product Dissection
-- PostgreSQL Database Schema
-- ============================================

-- 1. Users
CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Channels
CREATE TABLE channels (
    channel_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    channel_name VARCHAR(150) NOT NULL,
    description TEXT,
    created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_channel_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- 3. Videos
CREATE TABLE videos (
    video_id BIGSERIAL PRIMARY KEY,
    channel_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    video_url TEXT NOT NULL,
    upload_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_video_channel
        FOREIGN KEY (channel_id)
        REFERENCES channels(channel_id)
        ON DELETE CASCADE
);

-- 4. Comments
CREATE TABLE comments (
    comment_id BIGSERIAL PRIMARY KEY,
    video_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    comment_text TEXT NOT NULL,
    comment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comment_video
        FOREIGN KEY (video_id)
        REFERENCES videos(video_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comment_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- 5. Likes
CREATE TABLE likes (
    like_id BIGSERIAL PRIMARY KEY,
    video_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    like_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_like_video
        FOREIGN KEY (video_id)
        REFERENCES videos(video_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_like_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    -- A user can like a particular video only once
    CONSTRAINT unique_video_user_like
        UNIQUE (video_id, user_id)
);

-- 6. Subscriptions
CREATE TABLE subscriptions (
    subscription_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    channel_id BIGINT NOT NULL,
    subscription_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_subscription_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_subscription_channel
        FOREIGN KEY (channel_id)
        REFERENCES channels(channel_id)
        ON DELETE CASCADE,

    -- A user can subscribe to a channel only once
    CONSTRAINT unique_user_channel_subscription
        UNIQUE (user_id, channel_id)
);

-- 7. Playlists
CREATE TABLE playlists (
    playlist_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    playlist_name VARCHAR(150) NOT NULL,
    created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_playlist_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- 8. Playlist Videos
CREATE TABLE playlist_videos (
    playlist_video_id BIGSERIAL PRIMARY KEY,
    playlist_id BIGINT NOT NULL,
    video_id BIGINT NOT NULL,

    CONSTRAINT fk_playlist_video_playlist
        FOREIGN KEY (playlist_id)
        REFERENCES playlists(playlist_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_playlist_video_video
        FOREIGN KEY (video_id)
        REFERENCES videos(video_id)
        ON DELETE CASCADE,

    -- Prevent duplicate videos in the same playlist
    CONSTRAINT unique_playlist_video
        UNIQUE (playlist_id, video_id)
);
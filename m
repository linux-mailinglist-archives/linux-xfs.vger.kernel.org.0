Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6E13E3101
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Aug 2021 23:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbhHFVYE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 Aug 2021 17:24:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240209AbhHFVYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6B0yb7v6PKgk06U5usz2NFFgSoPgZA0GB5BpYO6ioKU=;
        b=DoJ0amIm7peyH56O26A1JqjLtCdywEl6MSpkFrnmbGiCjWhKZDoH+sAPwrdMwLNp0vz22D
        FUDXHoHosReX1FjxO9l45VROhJgDAlMm7esLkJQ2dyMT/1ec15s0E1SMoHfEGiAmxo5iy8
        H6RVpBjifI8UqobEONYIktNluLyz0xw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-M3SquknFNXe8_xcbnzxfMw-1; Fri, 06 Aug 2021 17:23:46 -0400
X-MC-Unique: M3SquknFNXe8_xcbnzxfMw-1
Received: by mail-ed1-f72.google.com with SMTP id g3-20020a0564024243b02903be33db5ae6so1422534edb.18
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6B0yb7v6PKgk06U5usz2NFFgSoPgZA0GB5BpYO6ioKU=;
        b=ru+w+L3Mr1cjpjtpHVvPuLJYgSMqBO8Y9lXCmcgzX3QT6aZCCxp8/l7Xm0RawkWPs2
         8hi9ycAE3JoSiiw1vfwhtsn0zeg1DQZSd13LMllFyIKxwJ97A3jtmly/H7zreFWXffgM
         AbhDXATg8VqCA+XVHptUU2LMumbjvNIBcycSJDtPjxYJV1xvaPCZpkHXpnGAbwOR7uOD
         ihnV+25cEDsiN2A56PXmYTKYR0S9+kf+9P/Usrs1tZDyYcqn00JL1vZWtfZkrjHVRdDV
         zeu2HE4ze6gzGweuCj2gcuui8IyHYu54J4w+Qwbx15akxns0jdobwbrKwlgOUrBJ1hbH
         ZcVA==
X-Gm-Message-State: AOAM531nzLfGbfj1aafD8E3+Ztkn/fMDhq7bROxFBtdZlHC4v2q4mc3j
        wPR6QwjXgqsddndrD7i7E/4WtRfyTcuRnTy/RvPBo3zVkZEpmGq0UFgs6//2F+j3IVD1mCReuse
        P2Di36gEE/WvnuXdlJPDMZNgtUsvK/u52U/o4vwWx2/XWpl2mfQC82QcCZxXdgE2uXTiLfwA=
X-Received: by 2002:a05:6402:60b:: with SMTP id n11mr16064209edv.235.1628285025084;
        Fri, 06 Aug 2021 14:23:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRC2O/76SkYg9K4b6lF+KqB5z/9chBiQNBCw6jmYB3fYeGOos6M/FPcjXqD77YmaVP4syy4A==
X-Received: by 2002:a05:6402:60b:: with SMTP id n11mr16064196edv.235.1628285024856;
        Fri, 06 Aug 2021 14:23:44 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:43 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 17/29] xfsprogs: Stop using platform_mntent_close()
Date:   Fri,  6 Aug 2021 23:23:06 +0200
Message-Id: <20210806212318.440144-18-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 fsr/xfs_fsr.c   | 2 +-
 include/linux.h | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 825ec395..42f477e8 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -369,7 +369,7 @@ initallfs(char *mtab)
 		mi++;
 		fs++;
 	}
-	platform_mntent_close(&cursor);
+	mntent_close(&cursor);
 
 	numfs = mi;
 	fsend = (fsbase + numfs);
diff --git a/include/linux.h b/include/linux.h
index 07121e2b..7940fe8c 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -191,11 +191,16 @@ static inline struct mntent * platform_mntent_next(struct mntent_cursor * cursor
 	return mntent_next(cursor);
 }
 
-static inline void platform_mntent_close(struct mntent_cursor * cursor)
+static inline void mntent_close(struct mntent_cursor * cursor)
 {
 	endmntent(cursor->mtabp);
 }
 
+static inline void platform_mntent_close(struct mntent_cursor * cursor)
+{
+	return platform_mntent_close(cursor);
+}
+
 #if defined(FALLOC_FL_ZERO_RANGE)
 static inline int
 platform_zero_range(
-- 
2.31.1


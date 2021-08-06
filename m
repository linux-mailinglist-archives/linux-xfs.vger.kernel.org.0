Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F063E3109
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Aug 2021 23:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhHFVYQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 Aug 2021 17:24:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240338AbhHFVYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfAktOPlA7PYs6WFbtBi/M9gpwd7ZVMtsNCcv9MwvKY=;
        b=ACdBchSbvBWUvtj0nutUA+SMJ7FT8PaEcUo0L2eS68dQkxWYsoCd3i8EZPIMDf0L01nfWX
        eSIHupHaVZigbwBAh+d4WnBk4ZNaFTWMvWDt8PQQ8JgFGu5rvqpSB5wFL0AFwL7/IXUv9q
        oJOS3gq2xyTjkueRiVfygpm4bD0i8RM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-ZxBZTSa7OFeD9pa8Vw91og-1; Fri, 06 Aug 2021 17:23:58 -0400
X-MC-Unique: ZxBZTSa7OFeD9pa8Vw91og-1
Received: by mail-ed1-f71.google.com with SMTP id l3-20020aa7c3030000b02903bccf1897f9so5559971edq.19
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HfAktOPlA7PYs6WFbtBi/M9gpwd7ZVMtsNCcv9MwvKY=;
        b=QdFIE1pos9J/2moUDgO3XWpcrS4AkNVBh6ESgbPW3TZZki9tT1Sy9YhVwaiwu9Uz4x
         nW2JZTM6Qys7X3RDstHKYgEaSbGbFPYhn7/EfAKj4WCSWPFvchliQ9cmYjvA1xw3iAJJ
         J2nZE6+yzUYsQr2jYs1MBjVbOd2wNhZmxnFpX1+f2diXS9kgZWMAFK13Jjb/WHWnERWj
         kOESUwQtt+DLAmpQrR1nNAJcsyCdinxzgMvdsWhYw57/BKOcoVE/5qMciri3irSZkEBo
         NB1WZ9aJSq44nFjOemPUU/P7ZvpcnZuJrq5s/CA0oDeWJwvbFp7yV/0eHsZboEoCRylr
         b8cw==
X-Gm-Message-State: AOAM530zdKGeAQKdfZ9U51jwfIcSH6ih8VyLe06Ex9zBOw/3y8iXIN1W
        BFJnm/3blc/IwhQzv6wdJ/EO+OhF43IrhFrin+GE82bwwT8mKKTPnzMJT0kaYHLXPLMRtkEy5W/
        fb8jFFby1Dm3XJdFYPC+Xz4TBb4PNC9DXBHQ7vAHEHHT1q5oxxnEqhgZyXGe9b16TE01PG7U=
X-Received: by 2002:a17:906:6d85:: with SMTP id h5mr11647029ejt.305.1628285036783;
        Fri, 06 Aug 2021 14:23:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrD/gRhMjWlC8iFNOV6larpdMPthF/V9MGMH/r7XDOsIfSfXAgJtoy3lCpgmGcCiWbNzOgCQ==
X-Received: by 2002:a17:906:6d85:: with SMTP id h5mr11647021ejt.305.1628285036600;
        Fri, 06 Aug 2021 14:23:56 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:55 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 25/29] xfsprogs: Stop using platform_findrawpath()
Date:   Fri,  6 Aug 2021 23:23:14 +0200
Message-Id: <20210806212318.440144-26-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 libfrog/linux.c    | 8 +++++++-
 libfrog/platform.h | 1 +
 libxfs/init.c      | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index 796fb890..31ed59c9 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -270,11 +270,17 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 }
 
 char *
-platform_findrawpath(char *path)
+findrawpath(char *path)
 {
 	return path;
 }
 
+char *
+platform_findrawpath(char *path)
+{
+	return findrawpath(path);
+}
+
 char *
 platform_findblockpath(char *path)
 {
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 06519a0c..832eb41a 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -18,6 +18,7 @@ int set_blocksize(int fd, char *path, dev_t device, int bsz, int fatal);
 int platform_flush_device(int fd, dev_t device);
 int flush_device(int fd, dev_t device);
 char *platform_findrawpath(char *path);
+char *findrawpath(char *path);
 char *platform_findblockpath(char *path);
 int platform_direct_blockdev(void);
 int platform_align_blockdev(void);
diff --git a/libxfs/init.c b/libxfs/init.c
index 46e6e225..d7166b69 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -200,7 +200,7 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 		perror(path);
 		return 0;
 	}
-	if (!(*rawfile = platform_findrawpath(path))) {
+	if (!(*rawfile = findrawpath(path))) {
 		fprintf(stderr, _("%s: "
 				  "can't find a character device matching %s\n"),
 			progname, path);
-- 
2.31.1


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E40CD39C6
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2019 09:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfJKHDa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Oct 2019 03:03:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35791 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfJKHDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 03:03:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id 205so5522236pfw.2;
        Fri, 11 Oct 2019 00:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=H/6iiROPMKo0TlgNSl+l8IPOTIC7KwQPg0RdMpmm4+E=;
        b=s/OF2m/IWfUirr+JOKnWUvbGSrWyeRBwUx9H75uKHXZRO3NwN4J7wGHADKTr6uhKlD
         qOszXumDcCEhvY2gr6AoUjeXHsHnxBAUA6rDw/kH74iwOEA4LMGPyp6pJr+dL6ItF6qI
         /G5YCmu/shX31DO/WxQ6JThvcape91n+tvJ0OCetrVtvBaUe0Wj8hi50DjrvR9sgBrBI
         xrIF0114KIr7kIr2dFSj7XIctAS8yY6GuZwwwNoWBEdArb5zvdRo4XNJH62JHKGoKbxH
         Tid5A0RMr9f0IIBceLKwrpoF4X2bTfTEMZfwrQZdBIx7DB+TrhI3uzGryuYg4ISGWaxl
         hQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=H/6iiROPMKo0TlgNSl+l8IPOTIC7KwQPg0RdMpmm4+E=;
        b=qYg692QgR4Gupe7QjrkG8ZVoBPy5ws0FpOqGA0Xh1VeS5kMWqPo4iVj6FX0VrvJT0r
         pgVr7OCBdXWbL+mQbbbUIu6pNN/JovDhD8SBeL3ZmeoTq+eX5MGkZscSq3E5SYDTNxsP
         MFHWemvogD+GWlQQjWgviPmWb7VikHMeWICAs6Cz8qwocZT8N/XO+da4cQaPAJO1ZSjH
         cJYpTXM0VCWA16ZYZeCklPUkPkTxHNQaSsbrhmBYbo1NWTYYN80fTH4fsV1e4w3mEKFL
         pvainxeuDGnEOCuEcQHQe3HJnyxhZ4Lqg604lfotz9MIoxVuXpie+a/DDiwkxMd88zMg
         siYQ==
X-Gm-Message-State: APjAAAUVTE40WKQm41eZGlSXizo2ZtOeWJ3TN7YDNvGyTH7SGwLqWfyz
        //qzUwbPlRiiVtlOU4amHUuKL8U=
X-Google-Smtp-Source: APXvYqzoxoGv4cvnD6T2JXXkeV0hzNUq7qGX1844tO/wil/Sp0fIi3td7kuS4vzm3sSLxYkTVHWSoQ==
X-Received: by 2002:aa7:93c3:: with SMTP id y3mr15126067pff.2.1570777409630;
        Fri, 11 Oct 2019 00:03:29 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id 7sm6752627pgx.26.2019.10.11.00.03.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 00:03:29 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        newtongao@tencent.com, jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH] fstests: remove duplicated renameat2 system call number for
 i386
Message-ID: <6d0c1a12-b4b2-cb35-1150-001ffa83a5db@gmail.com>
Date:   Fri, 11 Oct 2019 15:03:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove duplicated renameat2 system call number for i386.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 src/renameat2.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/src/renameat2.c b/src/renameat2.c
index c59ce65..8f712a4 100644
--- a/src/renameat2.c
+++ b/src/renameat2.c
@@ -18,10 +18,6 @@
 #define SYS_renameat2 353
 #endif
 
-#if !defined(SYS_renameat2) && defined(__i386__)
-#define SYS_renameat2 353
-#endif
-
 static int renameat2(int dfd1, const char *path1,
 		     int dfd2, const char *path2,
 		     unsigned int flags)
-- 
1.8.3.1

-- 
kaixuxia

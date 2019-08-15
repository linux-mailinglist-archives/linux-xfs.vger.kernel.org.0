Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1F8F5C9
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Aug 2019 22:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbfHOUcK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Aug 2019 16:32:10 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]:41160 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731068AbfHOUcK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 16:32:10 -0400
Received: by mail-qk1-f174.google.com with SMTP id g17so2897526qkk.8
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 13:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=gTy9uU5C7Eg17ABGTUwvcikPBai0Yt84JZ4pgqWcnZY=;
        b=jhbl7LqDLV2skjii9AwVNFrVzN8EK0fKbNddXWm6q27JpNhgVwXiOi3lYvWbn841S5
         OMI7apLQ1RixIWBSe+euAUbB+64X2zVev00Awq9ycSNylKYssNVzvGS2ZGuNpia2sAxP
         PBFIicbZTjZoBz+MpipfvZsfzeWkYI/LrYwa/sUshgC3eGL91PlN/Z0iA3Z/Qv9ps2Sk
         42s7RUvxjLry7D9tE10agDsATimdmZffzQiWmPXUsHWzjDWlEZnB1+chuZaqT3200oPe
         pOs8kjJxtjujKXf8hLduEjXiNczGsALBkIDyXmJ83+Uldk5mh36ZzgNHnr55whG0JHH/
         SZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=gTy9uU5C7Eg17ABGTUwvcikPBai0Yt84JZ4pgqWcnZY=;
        b=HB4WIbzCI82zYejiilyYgDohWtrk6pZ5lCJzmRZwBxSaN0eYVdEWtgHZh25o2dekE3
         R94YBj+9FqI9uKa1dVy4no5u3j7cBXf4tcQIONuzG19emVht67bExqZadMpi41t4z7ao
         Aa39hhfgcrVA13Ie358aWZukLIF7aGxZf/mnhy1tEuOA+GA52a81yKUa5KH/z2ybVs0k
         oUMpouOvqXy1FUTyGZVfCsiZXFSxcgGId+I3TMBwUlaqtII1kdMFOz5xczNgo0xW5tRA
         iJv+oElHXHJlpSzX1o1mJnKrIEEJxUyvKvX7HSmiUq+ZmTNBtpzZGy/s2XKYap2nRxsU
         Mz3g==
X-Gm-Message-State: APjAAAVz+LDgYuDqycnbIuf6LrteBnf1lUPx4zmtQPkeHZlMGzy+i4DB
        enf0Lyc6yZA4O3WlMej/o5VR4H4=
X-Google-Smtp-Source: APXvYqxuaulNbTbJKd8kSOSVeAgQmAZIINWhyNqRX/E1Bp6pglcldNfe2vCyHBr0PoVN6U8smxXr8Q==
X-Received: by 2002:a05:620a:112b:: with SMTP id p11mr6031692qkk.146.1565901129083;
        Thu, 15 Aug 2019 13:32:09 -0700 (PDT)
Received: from lud1.home ([177.40.130.28])
        by smtp.gmail.com with ESMTPSA id o43sm2265810qto.63.2019.08.15.13.32.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Aug 2019 13:32:08 -0700 (PDT)
Date:   Thu, 15 Aug 2019 17:32:05 -0300
From:   Luciano ES <lucmove@gmail.com>
To:     linux-xfs@vger.kernel.org
Subject: XFS file system refuses to mount
Message-ID: <20181211183203.7fdbca0f@lud1.home>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If this sounds familiar, it's because I've been here before about 
this same problem. New events are at the end of this message.

I've had this internal disk running for a long time. I had to 
disconnect it from the SATA and power plugs for two days. 
Now it won't mount. 

mount: wrong fs type, bad option, bad superblock on /dev/mapper/cab3,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so.

I get this in dmesg:

[   30.301450] XFS (dm-1): Mounting V5 Filesystem
[   30.426206] XFS (dm-1): Corruption warning: Metadata has LSN (16:367696) ahead of current LSN (16:367520). Please unmount and run xfs_repair (>= v4.3) to resolve.
[   30.426209] XFS (dm-1): log mount/recovery failed: error -22
[   30.426310] XFS (dm-1): log mount failed

Note that the entire disk is encrypted with cryptsetup/LUKS, 
which is working fine. Wrong passwords fail. The right password 
opens it. But then the partition refuses to mount.

I've tried xfs_repair -n on it and got this:

Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...

It prints an endless stream of dots for a very long time then it 
says no file system has been found. 

Is there something I can do to recover the data?

The new event is that I am cloning the partition to another one 
with dd right now as I type, and I would like to know how I 
can use that to fix the partition so it's mountable or if I can 
at least scan it and rescue any files.

Thank you in advance.

-- 
Luciano ES
>>

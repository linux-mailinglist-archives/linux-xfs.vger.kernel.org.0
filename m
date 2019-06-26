Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE95729C
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfFZUcP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:32:15 -0400
Received: from mail-yw1-f52.google.com ([209.85.161.52]:33855 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZUcP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:32:15 -0400
Received: by mail-yw1-f52.google.com with SMTP id q128so75764ywc.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 13:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=editshare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=0wnPbmkpx4E3poeNRrq6YPQVy7U0Z19itZT7nonxG/I=;
        b=Ne27eTqHwmm7NAhDRbZph+6j/e8y0FXwkET7ZjLrV0wAgBBIN2OwN/U1t6950O6Yh5
         oYRBVZvyduvXqOGWM8F8skg9BKhA6n5uUGjnmVlJNeGPkWbNKjFBNyfa/yGYwsDvsooT
         ho3Z/POIuaixq/MsgUJpA34aYuiqBUXnogO4GOauyUzy13YRQhm6wEV9m2Hkdcm+SHSA
         IXgJKsnvx4YyyrQfR2Pwc1hCpzcM3XYhrTvkR+OplhNzRQC/v7sNa1qNZlhlVmrQWyBJ
         sP1PdUR49tcXW+LaN5IKK/5VF0unjxfNmvd3nvu39d+FEYm3kVV4CAfTB2Pk8jFXWoQ8
         Hsvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=0wnPbmkpx4E3poeNRrq6YPQVy7U0Z19itZT7nonxG/I=;
        b=OnFXBeF4DTqWv3h3kMzbfQ2zDdBKlK1h4q15UBYpSOCjNWVfeZearkJPp+U2BqbmLA
         s8xOEm5lqAqwpgvr3HxBorFz9XlNTZJd7nunBjB1nfA90elox/A1l8HyiAbnkB/h9Gwp
         d3KplGMOVEo5eLQyQS0xrTzt8DSs//vpJaNjD1N8rFgtYc8+/6KZBgPNgnEORgjUw4Fm
         N4yLHnbQcqTWV6BqpsXAl6ypEJhNmD6COQSOZO88wyyWkj/UjN6X5lr1MYZxoUIGSnCd
         +NMQ4zvPQj12MnMDkdGOGfbrp8DK2EGAbqgnLItAXwPvZ1vlM26XvMW5og7t+peMTZ8N
         8nTg==
X-Gm-Message-State: APjAAAVkw7CCQ7U3Zm3NYg8N9/NO2h1wyzzL+8URhHzisRnBE58q46Dr
        qwT30B0mZumIw+cI1RzkIkRDMw1J62VXUe79/r4tJvQ7zPWfig==
X-Google-Smtp-Source: APXvYqwf5Me3U7ghauaBn1t1bOu0/jboybYsgffT2L1R9MZSvhdoI70y+RUXVtDSKkIlfUITuG+wIyLz6syjlUMh6qA=
X-Received: by 2002:a81:13d4:: with SMTP id 203mr4195784ywt.181.1561581133780;
 Wed, 26 Jun 2019 13:32:13 -0700 (PDT)
MIME-Version: 1.0
From:   Rich Otero <rotero@editshare.com>
Date:   Wed, 26 Jun 2019 16:32:02 -0400
Message-ID: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
Subject: XFS Repair Error
To:     linux-xfs@vger.kernel.org
Cc:     Steve Alves <steve.alves@editshare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I have an XFS filesystem of approximately 56 TB on a RAID that has
been experiencing some disk failures. The disk problems seem to have
led to filesystem corruption, so I attempted to repair the filesystem
with `xfs_repair -L <device>`. Xfs_repair finished with a message
stating that an error occurred and to report the bug.

The requested files are in my Google Drive (links below):

xfs-repair-sdb1.txt: This is the output from `xfs_repair -L
/dev/sdb1`. I could only save as much as was still in my `screen`
buffer, so the beginning of the repair may be missing.
https://drive.google.com/file/d/1CTm4hUumqPLW6FUSnc2ykU-hzH1w0Yug/view?usp=sharing

xfs-meta-sdb1.bin.tar.gz: This tar archive contains the file generated
by `xfs_metadump -g /dev/sdb1`.
https://drive.google.com/file/d/160If17YDVdk5_hEhajlMpFcTvGeIqZsd/view?usp=sharing

Regards,
Rich Otero
EditShare
rotero@editshare.com
617-782-0479

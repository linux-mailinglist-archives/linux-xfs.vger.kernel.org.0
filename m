Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2850D57346
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 23:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfFZVEU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 17:04:20 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:44593 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFZVEU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 17:04:20 -0400
Received: by mail-wr1-f46.google.com with SMTP id r16so4305510wrl.11
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 14:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OQXiHKJWXYEP+fTx7sC8fjNrMth15wOmnnlWgbhkBDc=;
        b=DFG0qHAl8coLR6N04uHPt+HE2sQ7y33fbfVmAi8Z0VXvpImlAYVyKSbzDRf2rZOSXE
         Aemioxe6sb48OGKLWI4cqLdBjugprJX6fHwYLJDvlmrscTzmGVeTJ33qQj9Jvdg3TSaK
         SA9HMoGjag4kKTaFaI1Wd7jLctVQn0YvDht696mEnci9MFdNUUW39njaakVvIdkU0kYr
         QJM6hsGiTjNh25BtAKWbrmggPP24f4uAbYHZXEIgiKotiWIY9iuzDls3YfDRkqiQA2x/
         WP0wv+7h1DqE8rrVy+ea1cHqHu6eGq4bfwLS9oNI/+dR8U0AsYrvo2/bkDJBOZ32aLb6
         Zo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OQXiHKJWXYEP+fTx7sC8fjNrMth15wOmnnlWgbhkBDc=;
        b=QGwyEK4DUhiiK4mby2jt8MFuNtlE4BPx9Ct+otV2t2anLmIohASl45zJElQ7N1uHOc
         9kj8YNAyNGFyHsycaGTa+IZkoL7NeLA3F4irLhfiCIRmsM45nFPrwl8/ACoEyqm/XAcV
         Ggf94heayhh4lKyDAz5IH0a4TzjSndMaBeNY0qlJTKI1uhTEmbpiHFTGT72ZofCbtuks
         a3QH56D565gUl0WwujcpPnRl8g6fc6acjjYGOOtNAFdgWDfDyQIIeBxeZ+tBoheNw4yA
         Fc61Myl+sMLcVOULOYOEj5+Euz/DwxJCbWfVviYamRnrv/mwb7lw0d0ic7P3YAT7cxEa
         +wXw==
X-Gm-Message-State: APjAAAWkyNwJDwKb6KRs6G764pcaKq1QB6rsBMHlXbH8ysmyNLl8uCgr
        +wwNGGRILI0B00unQVlq2MxP3Mb1tZtg2IRI02RsEp5aaDmvFA==
X-Google-Smtp-Source: APXvYqwf+P39iYnbnI38uzRKAI+N+JWu3USjOc3AOkiWXLR5Un+R7o8Vx9ViBmwQi65fCAYXfwoKtg1P2tah+56OBaY=
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr5254409wrx.29.1561583057648;
 Wed, 26 Jun 2019 14:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
In-Reply-To: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 26 Jun 2019 15:04:06 -0600
Message-ID: <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com>
Subject: Re: XFS Repair Error
To:     xfs list <linux-xfs@vger.kernel.org>
Cc:     Rich Otero <rotero@editshare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 2:32 PM Rich Otero <rotero@editshare.com> wrote:
>
> I have an XFS filesystem of approximately 56 TB on a RAID that has
> been experiencing some disk failures. The disk problems seem to have
> led to filesystem corruption, so I attempted to repair the filesystem

This applies
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Also, are the disk failures fixed? Is the RAID happy? I'm very
skeptical of writing anything, including repairs, let alone rw
mounting, a file system that's one a busted or questionably working
storage stack. The storage stack needs to be in working order first.
Is it?

> with `xfs_repair -L <device>`. Xfs_repair finished with a message
> stating that an error occurred and to report the bug.

OK why -L ? Was there a previous mount attempt and if so when kernel
errors? Was there a previous repair attempt without -L? -L is a heavy
hammer that shouldn't be needed unless the log is damaged and if the
log is damaged or otherwise can't be replayed, you should get a kernel
message about that.


-- 
Chris Murphy

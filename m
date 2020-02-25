Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0563D16B956
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 06:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgBYFxi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 00:53:38 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41281 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgBYFxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 00:53:37 -0500
Received: by mail-io1-f66.google.com with SMTP id m25so565204ioo.8
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2020 21:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCfzzwTgdVO/FVxHYz/BLmGFQ8B2u4JefNipnicYISA=;
        b=eBaJR7V+fn5JwhrE2b75rjzEMj0SXODs/HnyM9SDXIZN7qhkKAnKstsBrDeXB74ItQ
         Go2kebfBBrOOnIR1B1ggPbEg/+gCTvhoSDdbFLT5qnHDGGQPNQPD/Z1OTwD7nlvOttii
         Jf7JZNaQUGIek7S07+iyapG2qhZ2cdC6aMWPNL3l1oaFZUd6/xeGDExE9RimsJcUO1b3
         zL+YLaecyqFROfW0GAkguIT1suqQzMMDQAb+zJViXHiceM2//kaTRE03134rJx2T/cr2
         AxNX9/wsIu3v5jK0bS3tqQ9kc1tKA3GhpozLktc9PgksyFndhtFGl+nHfcUiiohwr/5T
         2X/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCfzzwTgdVO/FVxHYz/BLmGFQ8B2u4JefNipnicYISA=;
        b=V8UhJxBXyVQtu0uG+OFRWn2TX+q93UDBNTSc75kEJsm+grBwCCq3m3BLWY4bVCPUQi
         e1QQrgY8X//pGAVhNwqltwvEzooxbefGvVNKv7yllP4oLxriPCX9vmAo9vi1GFKUAgQP
         uMPWqu2sYgCsBPgyzBP6MTqPPeXhXlyadMPqu39eGt30F7R4vEF7nA8MT0nI8710/1IR
         N5jPuCLP8QtzHE0t1UKq+ehhCGEbh1K/al7IPfLa9cuRqA6olzANJbXQEIb5ySp276ap
         pwEp4UIsdqasPtyGgEsavKDRjDorQqvviDWQqT/9WwJj1/L8CGguckBiTLseZX+Kuhna
         4njQ==
X-Gm-Message-State: APjAAAU1Q9ECNtUNxCQYru80pD7L5RIJG/3BUZcVTN7YYyz0R1HbE6ba
        jdPVNsedJ0K3+3yUa+3NS9/zeSj/8b/AKi8OhtrFeA==
X-Google-Smtp-Source: APXvYqzr85kpWkXpAtfoqGULzJo0wlZKMUYTvdKj3iDEdqqNGaP9WASe3rqLXNVo5BmcvwtEN+eSvPDtEhv3RZiKGes=
X-Received: by 2002:a02:8817:: with SMTP id r23mr56156926jai.120.1582610015849;
 Mon, 24 Feb 2020 21:53:35 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
 <5b2ade02-0f1b-b976-2b38-d10fcb41d317@oracle.com> <CAOQ4uxhhW2ZMVdF8zvHRPk65wsJTMn55tnCrJ7BVQK1CSAu3gQ@mail.gmail.com>
 <dedb52cd-fb96-2357-f29b-f2ae7813e83e@oracle.com>
In-Reply-To: <dedb52cd-fb96-2357-f29b-f2ae7813e83e@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 25 Feb 2020 07:53:24 +0200
Message-ID: <CAOQ4uxiWk5qdTu5MVYOECkNZPKX+Hp_WUh-RaxW19BvwXEoUWQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/19] xfs: Delayed Ready Attrs
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Ok, I think I understand what you're trying to say.  Would it help to
> explain then that setting or removing an attr becomes part of the
> namespace operations later?  When we get up into the parent pointer set,
> a lot of those patches add an attribute set or remove every time we
> link, unlink, rename etc.  Did that help answer your question?
>

I will wait for the parent pointers series,

Thanks,
Amir.

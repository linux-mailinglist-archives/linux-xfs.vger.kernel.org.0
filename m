Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E759B475
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2019 18:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732570AbfHWQ3D (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 23 Aug 2019 12:29:03 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34435 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389546AbfHWQ3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 12:29:02 -0400
Received: by mail-lf1-f68.google.com with SMTP id b29so7565797lfq.1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2019 09:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jQs1lkQOhvdXaQqoCDN3ZsfKd12RAhU3GnVdcQ5VGm0=;
        b=PiM2ii6t2uiPTKXhnQMteMVCqzKjT+tr515ovDOJdE/f2TkWyfyTI61bUM9LMrSsi5
         vFCfxybyVRCmVBTvGtBBv15CHyXg3peDy7FPE9mW+rETJWn8P6Sd6+WUmLGGKl+d2e6O
         1vh1mN452AFG7otyQe259IGTT7fLE7zX/AF18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jQs1lkQOhvdXaQqoCDN3ZsfKd12RAhU3GnVdcQ5VGm0=;
        b=NGg8bCR8M7zj3RFSfkRWzcy99OuYg21ebMhJylf5H794USBpXdxAhrIWcdDdg+nFQm
         pr74qXf/fZB5JteWM4KuxbZ6SkJ+P+uOCBl+oyTH1VBp0ELv8P0HrcVkSs1pJi3vVUCv
         y6YMp65rJ67qaYTTc5fmzhTUCKzgHKhrcRFrFc5Ubp5X2E8vEUiseGBJl0539EZOmipd
         SWnJn/TxCNJ01stKmNw3/ZmTxcRtKKvOXRrGVLRimkMCIcHUpw6m8QVcGbjVzOidQ4b4
         ds01i8HhG5SfXOaYBIUE/O8Ey0sfcoXY9Pv3aOlZdXpek42iJIF6A1/mknBjTcqtwcez
         +F1A==
X-Gm-Message-State: APjAAAXNysTr82anQI7uBubhy6SOhnyNbuycWabMg4aHSamnRRNW/Hff
        R+TAWmmJlXlUX4UQuKgjaFLT3Lxrb+4=
X-Google-Smtp-Source: APXvYqxIt4cAhXLQbydsD2JS2pephiAjHhFBVJGDY0QNR03ARYE1rm2BpczjHU5ZhUSubI5lHtEMJA==
X-Received: by 2002:a19:80c4:: with SMTP id b187mr3287866lfd.122.1566577739818;
        Fri, 23 Aug 2019 09:28:59 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id s21sm704862ljm.28.2019.08.23.09.28.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2019 09:28:58 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id r5so2055241lfc.3
        for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2019 09:28:58 -0700 (PDT)
X-Received: by 2002:a19:641a:: with SMTP id y26mr3290936lfb.29.1566577738342;
 Fri, 23 Aug 2019 09:28:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190823035528.GH1037422@magnolia>
In-Reply-To: <20190823035528.GH1037422@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Aug 2019 09:28:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiE1zyj89=gpoCn8L0hy8WpS68s+13GOsHQ5Eq3DPWqEw@mail.gmail.com>
Message-ID: <CAHk-=wiE1zyj89=gpoCn8L0hy8WpS68s+13GOsHQ5Eq3DPWqEw@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 8:55 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> ...which is clearly caused by xfs_setattr_nonsize failing to unlock the
> ILOCK after the xfs_qm_vop_chown_reserve call fails.  Add the missing
> unlock.

Thanks for the quick fix.

I assume there's no real embargo on this, and we can just add it asap
to the xfs tree and mark it for stable, rather than do anything
outside the usual development path?

The security list rules do allow for a 5-working-day delay, but this
being "just" a local DoS thing I expect nobody really will argue for
it.

Anybody?

                Linus

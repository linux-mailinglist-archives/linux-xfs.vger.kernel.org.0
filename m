Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9231662EA
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Feb 2020 17:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgBTQaw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Feb 2020 11:30:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42947 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728814AbgBTQav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 11:30:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582216250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Oqe+cJQncc+nPS2w9ErNobPJjqQjybc1SOb8/LvG9s=;
        b=A6LgkKFmM6kiMxvm6SSbQCqh7LsCI56axNpd62qjjPsMANVf7/7Nfv+KFjxW0sPvBdNIQm
        bm5YIP5B1XC7oSQnu3gSAtemKupaFZISYJiLWO40ZNsckkcE+miKCqtsgV9/s/dL7yFYhD
        CtmysooBnuCfG6bkO+jxss3olzLAT7E=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-_K09in36MU-RSJTAm3rdaw-1; Thu, 20 Feb 2020 11:30:47 -0500
X-MC-Unique: _K09in36MU-RSJTAm3rdaw-1
Received: by mail-vk1-f199.google.com with SMTP id q75so1602066vka.10
        for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2020 08:30:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Oqe+cJQncc+nPS2w9ErNobPJjqQjybc1SOb8/LvG9s=;
        b=P/QqRT92SsOu7A8z5UwiscTIYhhonksLG4S/j2urArWcHuUJZlPPlCVWAHKPsv2VU6
         FyIaQqeTwwcU220bcm9IzwNmAnU37VzIhVjjc040+BmIFU+4BMdGD6rJTBfWCbDJGPaV
         69i+Du8UmEKJOwvcK5dER8HmByaIUz6OnGc4iidsDs0amAncrO5UF/Y7Kjf0mAGmoqTs
         Ger9T4WlpkyyISWQBA8w0CGDKOp3/qhSth4RXCHfI+RCvGVpVAF5aJipBzvHUhyMVH3p
         m3eA+MNuEt9tF3WRx59A6ZOQeLu72cf6juyHn0e/xbscaRo2ltYBdXVAnb3NFZXZMwZ7
         xyrQ==
X-Gm-Message-State: APjAAAVAIiKfF+VyIWCFuQNqKDKbKyDNBtJQ4LKxzb4mMY6A+m1/aq3o
        X/upn+KrR6wVhkr2BrmmdN3i/NMvXy/kx+V/eQzH3sR2Md/YHWq8sEJ9PLQMwfZMMbA04OzduMJ
        Z/zUwtDGjEWcvXLKLIej95c+sd0h7DKJQExbS
X-Received: by 2002:a67:fc96:: with SMTP id x22mr18042710vsp.33.1582216246809;
        Thu, 20 Feb 2020 08:30:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqz2ISLvNWerEGz4dj0MApWDpPSN2PUaXT3IjMG6US7c0tGWmlHS7hLiA9mXdG2nUSFHwOFoBSdpVa9DhTCjcVY=
X-Received: by 2002:a67:fc96:: with SMTP id x22mr18042684vsp.33.1582216246395;
 Thu, 20 Feb 2020 08:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20200214185942.1147742-1-preichl@redhat.com> <20200217133521.GD31012@infradead.org>
 <20200219044821.GK9506@magnolia> <20200219184019.GA10588@infradead.org> <b718e9e9-883b-0d72-507b-a47834397c5f@sandeen.net>
In-Reply-To: <b718e9e9-883b-0d72-507b-a47834397c5f@sandeen.net>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Thu, 20 Feb 2020 17:30:35 +0100
Message-ID: <CAJc7PzU8JXoGDm3baSJo2jghOgzKEAHhAe9XvhLdE07JWe5WjQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 9:16 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
>
> On 2/19/20 12:40 PM, Christoph Hellwig wrote:
> > On Tue, Feb 18, 2020 at 08:48:21PM -0800, Darrick J. Wong wrote:
> >>>> +static inline bool
> >>>> +__xfs_rwsem_islocked(
> >>>> +  struct rw_semaphore     *rwsem,
> >>>> +  bool                    shared,
> >>>> +  bool                    excl)
> >>>> +{
> >>>> +  bool locked = false;
> >>>> +
> >>>> +  if (!rwsem_is_locked(rwsem))
> >>>> +          return false;
> >>>> +
> >>>> +  if (!debug_locks)
> >>>> +          return true;
> >>>> +
> >>>> +  if (shared)
> >>>> +          locked = lockdep_is_held_type(rwsem, 0);
> >>>> +
> >>>> +  if (excl)
> >>>> +          locked |= lockdep_is_held_type(rwsem, 1);
> >>>> +
> >>>> +  return locked;
> >>>
> >>> This could use some comments explaining the logic, especially why we
> >>> need the shared and excl flags, which seems very confusing given that
> >>> a lock can be held either shared or exclusive, but not neither and not
> >>> both.
> >>
> >> Yes, this predicate should document that callers are allowed to pass in
> >> shared==true and excl==true when the caller wants to assert that either
> >> lock type (shared or excl) of a given lock class (e.g. iolock) are held.
> >
> > Looking at the lockdep_is_held_type implementation, and our existing
> > code for i_rwsem I really don't see the point of the extra shared
> > check.  Something like:
> >
> > static inline bool
> > __xfs_rwsem_islocked(
> >       struct rw_semaphore     *rwsem,
> >       bool                    excl)
> > {
> >       if (rwsem_is_locked(rwsem)) {
> >               if (debug_locks && excl)
> >                       return lockdep_is_held_type(rwsem, 1);
> >               return true;
> >       }
> >
> >       return false;
> > }
> >
> > should be all that we really need.
>
> I think that's a lot more clear.  In addition to the slight confusion over a (true, true)
> set of args, the current proposal also has the extra confusion of what happens if we pass
> (false, false), for example.
>
> One other thought, since debug_locks getting turned off by lockdep means that
> an exclusive test reverts to a shared|exclusive test, would it be worth adding
> a WARN_ON_ONCE to make it clear when xfs rwsem lock testing coverage has been
> reduced?
>
> -Eric
>

OK, thanks for the comments.

Eric in the following code is WARN_ONCE() used as you suggested or did
you have something else in mind?

static inline bool
__xfs_rwsem_islocked(
        struct rw_semaphore     *rwsem,
        bool                    excl)
{
        if (!rwsem_is_locked(rwsem)) {
                return false;
        }

        if (excl) {
                if (debug_locks) {
                        return lockdep_is_held_type(rwsem, 1);
                }
                WARN_ONCE(1,
                        "xfs rwsem lock testing coverage has been reduced\n");
        }
        return true;
}


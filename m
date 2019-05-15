Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281321FBAE
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 22:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEOUrf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 16:47:35 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:41243 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfEOUrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 16:47:35 -0400
Received: by mail-pl1-f176.google.com with SMTP id f12so431796plt.8
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 13:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=hCSQTm0EH9NefFrALPeGOEdNIPIUXYAKnHYfhXJl2RE=;
        b=QMXR5JvN4n0oa91weHy66Lnlgb7TVRy3NFItA4i1JU1SkKkqYmq/WNRzkXkbpKEzeD
         /v693hZCjkEK+wvWXEHg/dd7GtxfeY2Rq05Ly5XmqfgqrkcLHwWciTTrCjW682hG5lES
         92CEtDNU5xsDVrK5wPjLwXsLCC+x7rcNB0/FFzy7JWw05hx0/ItuAiaH8HaUF9ucgVOK
         zpiYMW0jrel0zQF+9+20P74K/i3xLO0MpFDEe69O81X2v/iU69yxs7FOpI605x+Rxa0Y
         L4pf0jK5L0qsgux61+1laMQ4twXUMqgXv1xmP2xHyyAwwjZSpT4IM84yxjitKJlOjzUN
         D0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=hCSQTm0EH9NefFrALPeGOEdNIPIUXYAKnHYfhXJl2RE=;
        b=Tur/FBWmQHYgzq/SYq4RMVIo+8qyDZnYe4sDyiM6HiUrIM+s1ugYsOfZ1RwsxpXy1m
         qkFZp3Eu/QSfEGdfQRvRFhN+xErH7nHEiA0PE43SC5a3GAx+cV7rbcKVa6oBwlJSSVdx
         DseloMWpgBBaWbB3A5IS817bseyDwgttnizvgKURqAMYi3Zr6RLdPCaANb69ecAReVe+
         C+8fssFn1HZs1OCx9vh+DWrPYfuZvYwSkWYmcQ7x+Qi/mFK+gyDpX5gi/ESX/AWnv4UL
         k8nDkB9wnsq2orrP73IBQWbXTk5ozgpU6z6n/Xz/sKypqG2r8NivTVLpBJ5MGtTsxcr/
         fqZQ==
X-Gm-Message-State: APjAAAVQCiS8NYtwF5U3OlKGuc5E5hLx3068UdyR4JolxGIBt6ncCKay
        HlZZMoG0idNSiBqDLJrW1zh5YYrvAJM=
X-Google-Smtp-Source: APXvYqxXmEfI1w1B21xwYB/5A87tEzAiG7uPFOMPFYEoOi2TNeCv7WpAQClv0OARHCvnL/5d0nTpUA==
X-Received: by 2002:a17:902:3143:: with SMTP id w61mr38899713plb.292.1557953253816;
        Wed, 15 May 2019 13:47:33 -0700 (PDT)
Received: from vader ([2620:10d:c090:180::cdd6])
        by smtp.gmail.com with ESMTPSA id k26sm3682772pfi.136.2019.05.15.13.47.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 15 May 2019 13:47:33 -0700 (PDT)
Date:   Wed, 15 May 2019 13:47:32 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: xfsdump confused by ino's < root ino
Message-ID: <20190515204732.GA4466@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

We use xfsdump and xfsrestore (v3.1.7) to back up one of our storage
systems, and we ran into an issue where xfsdump prints the following for
a mount which isn't a bind mount:

/sbin/xfsdump: NOTE: root ino 136 differs from mount dir ino 256, bind mount?

Which also results in a crash from xfsrestore:

xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.

Looking at [1], xfsdump uses bulkstat to get the minimum inode number on
the filesystem. But, at least one of our filesystems has a root inode
number of 256 and uses inode numbers 136-199, which tricks xfsdump into
thinking that the filesystem is bind mounted. Is this an invalid
assumption in xfsdump, or is it filesystem corruption?

Thanks!

1: https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/commit/?id=25195ebf107dc81b1b7cea1476764950e1d6cc9d

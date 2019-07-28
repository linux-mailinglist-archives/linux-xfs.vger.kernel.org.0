Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B2377F34
	for <lists+linux-xfs@lfdr.de>; Sun, 28 Jul 2019 13:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfG1L0n (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 28 Jul 2019 07:26:43 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36473 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfG1L0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jul 2019 07:26:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so26423367plt.3;
        Sun, 28 Jul 2019 04:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CZB4/FK4WfyrnKFww5i1Y+nehlTsKGO3LjLr9ce8ZB0=;
        b=l0h6vYsyoHzRW8X3E65rDiGLkLgx4U6R4s7jrusW4md9tjNJh05XJrMfu24bS65h6T
         +CYinYSB+W5vXYDP338AwJGZRzyTZb7VxNSRLBKUhOzbkgmAhxMw5CA1WHnc8KSLLzqX
         Hg8lrVXN948nTZpxTxn7EfvmgA46afOlq52jxjROJ+li7CbF9sCU+zDj/VdEYl9FMExD
         foPTpZed1Ts/e8B3gxlUynuj4bDTmeh0awshrloVywmVZ4idigxK11cy1w7jo1dnaX00
         vv2OArEMy3lGU/DiKkUKHomfwFqCZfgCj8mKewua3Fgi1vz+kcMMDUzMJ6820GrQbjGn
         9dUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CZB4/FK4WfyrnKFww5i1Y+nehlTsKGO3LjLr9ce8ZB0=;
        b=jpzvYyXc888+OAPhPLu5T16/nY3MYTF/Q6+bOrVR4N1ImLbE7AK7rWczHQ5mkzlpJA
         Kgz0yUkJhA61FTXu6uke8F3/gOlpZEmNP7nL5FUjpYW/fDw0KyJXCZ3p6DAmSgryOi+/
         Z08dR1Gq8hUO0jvqaGO9wXotDK9/pzuMbhmMVc29U8KT35qZb0cO+6BbXwCbK/UkPJqh
         HKaNY3AVKfz2uznjyLeiITcNCzpijq5oQsg01gZQppkhc5UtFNJmKdSLFwnyXKXbER2L
         5ioUyiz0/I4ZJ43SEjPoAkzbE6Mfhvz0+tJC48mufX5QhFcwB5mSy5WeXGK3raj++fxW
         Fcqg==
X-Gm-Message-State: APjAAAWhUFIJuoJTI+i3OzD+eYcCdxUg6pnBIG6hdNFXeMhXUXQt/URv
        AXzvRzf/jOegn+HjbyYRSnE=
X-Google-Smtp-Source: APXvYqzDX+DH27w6zN0DMVBF9MAcvTUyQIiClJerlSBGB6EpxezH66u5tOQKRdVzyDz0eo9WDHxC0w==
X-Received: by 2002:a17:902:bd94:: with SMTP id q20mr94650579pls.307.1564313202060;
        Sun, 28 Jul 2019 04:26:42 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id j16sm44755417pjz.31.2019.07.28.04.26.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 04:26:41 -0700 (PDT)
Date:   Sun, 28 Jul 2019 19:26:35 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/4] xfs: fixes and new tests for bulkstat v5
Message-ID: <20190728112635.GN7943@desktop>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394159426.1850833.16316913520596851191.stgit@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi XFS folks,

On Tue, Jul 23, 2019 at 09:13:14PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Fix some problems introduced by the creation of the V5 bulkstat ioctl,
> and then add some new tests to make sure the new libxfrog bulkstat
> wrappers work fine with both the new v5 ioctl and emulating it with the
> old v1 ioctl.

I may need some help on reviewing this patchset, especially the new
bulkstat tests :) Thanks in advance!

But I'd suggest split the last patch into two patches, one introduces &
uses the new helper, the other one adds new tests. Also, it misses a new
entry in .gitignore file.

Thanks,
Eryu

> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bulkstat-v5
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bulkstat-v5

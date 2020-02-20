Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C20165607
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Feb 2020 05:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgBTEFY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 Feb 2020 23:05:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31359 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727756AbgBTEFY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 23:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582171523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YhkVa7qtSHIWT/rrXPInexA2kKheunisZ4SZ1pmov+M=;
        b=LdyRs9W1Dxl77QXoWxTVYh1f+EiydvqkN1iaXotuO+4mHZ2y/aOTsgKTpVGavC4x9c5txf
        QcsuM+0dd8ir5WIL4iWoqaDohVakd4uHLisgG1idEQIWGgb+oyI3oDjmEZOEhuCUhLpWyN
        O+7VGeKyIYvg2rx4euvsU634gSJ5ldk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-S52qvNFEOQmYSbDxKrtCRA-1; Wed, 19 Feb 2020 23:05:18 -0500
X-MC-Unique: S52qvNFEOQmYSbDxKrtCRA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CDB6DB62;
        Thu, 20 Feb 2020 04:05:17 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAD835C578;
        Thu, 20 Feb 2020 04:05:16 +0000 (UTC)
Date:   Thu, 20 Feb 2020 12:15:39 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] generic: per-type quota timers set/get test
Message-ID: <20200220041539.GD14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20200216181631.22560-1-zlang@redhat.com>
 <e54ae15f-6363-4486-0546-030e45ed50bb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e54ae15f-6363-4486-0546-030e45ed50bb@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 08:57:58PM -0600, Eric Sandeen wrote:
> On 2/16/20 12:16 PM, Zorro Lang wrote:
> > --- /dev/null
> > +++ b/tests/generic/593.out
> > @@ -0,0 +1,32 @@
> > +QA output created by 593
> > +1. set project quota timer
> > +*** Report for user quotas on device SCRATCH_DEV
> > +Block grace time: 7days; Inode grace time: 7days
> > +*** Report for group quotas on device SCRATCH_DEV
> > +Block grace time: 7days; Inode grace time: 7days
> > +*** Report for project quotas on device SCRATCH_DEV
> > +Block grace time: 00:10; Inode grace time: 00:20
> 
> One other thing that might be an issue here, I'm not sure every
> filesystem will default to 7 days if no other grace period is set ...?

Make sense:) I just hope to test the default grace time by pass.
How about:
1) Get the default quota timer $string.
2) Filter above default timer "$string" to "default".
to avoid defferent default timer breaks the golden output.

Thanks,
Zorro

> 


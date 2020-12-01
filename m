Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0751D2CAC09
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 20:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404368AbgLATYe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 14:24:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404354AbgLATY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 14:24:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606850583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WOvlm/2by5V81YbdnYUcfCHCjbYXKTUV3qAl9vLT98w=;
        b=G1uFtDqkAWLjUhX5soPnDtOXIu9pfE7IBTaSi/py0Pbh1P7ASH9jQay15jvjzUrEYkW185
        f53kO/xF1rVpE52Rd1qemkAn76Rf4bn9w+7MaWoBmoQUi4S22LX8zPWSNwjxLsg1bZFamb
        rjdTgrRyOZOetyeLCyz8vGCuNo1RgOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-moM0juacPHuFCfBqqoTWVQ-1; Tue, 01 Dec 2020 14:23:01 -0500
X-MC-Unique: moM0juacPHuFCfBqqoTWVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 792CD8558E8
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 19:23:00 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 505B65D9CA
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 19:23:00 +0000 (UTC)
Subject: Re: [PATCH 0/2] xfs: fix up some reflink+dax interactions
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
Message-ID: <7680868b-d804-faf2-9fbd-f03ca8a69fdd@redhat.com>
Date:   Tue, 1 Dec 2020 13:23:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/1/20 1:10 PM, Eric Sandeen wrote:
> dax behavior has changed semi-recently, most notably that per-inode dax
> flags are back, which opens the possibility of dax-capable files existing on
> reflink-capable filesystems.
> 
> While we still have a reflink-vs-dax-on-the-same-file incompatibilty, and for
> the most part this is handled correctly, there are a couple of known issues:
> 
> 1) xfs_dinode_verify will trap an inode with reflink+dax flags as corrupted;
>    this needs to be removed, because we actually can get into this state today,
>    and eventually that state will be supported in future kernels.
> 
> 2) (more RFC) until we actually support reflink+dax files, perhaps we should
>    prevent the flags from co-existing in a kernel that cannot support both
>    states.  patch 2 stops us from reflinking files with the dax flag set,
>    whether or not the file is actually "in the CPU direct access state"
> 
> -Eric

Also yes I owe xfstests for these but wanted to see if the patches fly, first.

-Eric


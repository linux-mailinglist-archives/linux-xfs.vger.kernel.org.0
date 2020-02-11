Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FE2159204
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Feb 2020 15:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgBKOeH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Feb 2020 09:34:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23147 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727818AbgBKOeH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 09:34:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581431647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e26/WBpYXspMJp83H67T4hVEyOnq9qZB1jvr6DlXa9M=;
        b=ARuBv5c2ZIjqTLzSoxO6uXOjQHardCG+Y9d1v4PxozmaMRP4QSr17LuSCbCM160ULTlcJP
        NOUHQS8b6bdRjpm7zkGknw6MEk/oogxaw0Vv2bLuE7v9ICM17anLkJnpWrTJ1+dgKJQDJF
        n0YBTi2ycfi96zmt++wfgv8ySOCry6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-qieXoAkYNu2PQdZ15KPLGw-1; Tue, 11 Feb 2020 09:34:03 -0500
X-MC-Unique: qieXoAkYNu2PQdZ15KPLGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5DE08017CC;
        Tue, 11 Feb 2020 14:34:01 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CAB75D9E2;
        Tue, 11 Feb 2020 14:34:01 +0000 (UTC)
Subject: Re: [PATCH] xfs_repair: fix bad next_unlinked field
To:     linux-xfs <linux-xfs@vger.kernel.org>, John Jore <john@jore.no>
References: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
 <20200211090836.cims7r4jvrds2e7w@andromeda>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <daca5723-5631-31f8-a163-bc024d8b7111@redhat.com>
Date:   Tue, 11 Feb 2020 08:34:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200211090836.cims7r4jvrds2e7w@andromeda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/11/20 3:08 AM, Carlos Maiolino wrote:
>> +	unlinked_ino = be32_to_cpu(dino->di_next_unlinked);
>> +	if (!xfs_verify_agino_or_null(mp, agno, unlinked_ino)) {
>> +		retval = 1;
>> +		if (!uncertain)
>> +			do_warn(_("bad next_unlinked 0x%x on inode %" PRIu64 "%c"),
>> +				(__s32)dino->di_next_unlinked, lino,
> 				^^^^
> 				shouldn't we be using be32_to_cpu()
> 				here, instead of a direct casting to
> 				__s32?

Yes, good catch.  I was looking at the version check which just does (__s8)
but of course that doesn't need the conversion.  I'll fix it here, thanks!

-Eric


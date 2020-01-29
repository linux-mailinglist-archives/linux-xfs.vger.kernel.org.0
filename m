Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61C314CFC7
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 18:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgA2Rlf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 12:41:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41382 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726679AbgA2Rlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580319694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9MDYM6N2zx4TYEoR98U2s08TtT/6vb23+O0IFJIOheQ=;
        b=B1eyt11BAamsCT9jGDNA68EauM7wy5lxh2QWwsAo8gm+xT4uN9V1A0gw6arsv7oPHW5cCo
        oAMbXnpRtNNY3KiRJK7IECPDZFXKhizg5fSn0ObMk0OvrJzqIQfijmwir7mfTLp06+0wg5
        lJBSOV8C0n5/SrNF+b7TcPhmuZBcRDM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-UuBk3iwWNmeROsiS5AaxHA-1; Wed, 29 Jan 2020 12:41:32 -0500
X-MC-Unique: UuBk3iwWNmeROsiS5AaxHA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2300E18C43E4
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jan 2020 17:41:32 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF03E60BF3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jan 2020 17:41:31 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: don't take addresses of packed structures
Message-ID: <65e48930-96ae-7307-ba65-6b7528bb2fb5@redhat.com>
Date:   Wed, 29 Jan 2020 11:41:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

newer gcc complains when we try to get the address of a packed structure:

xfs_format.h:790:3: warning: taking address of packed member of =E2=80=98=
struct xfs_agfl=E2=80=99 may result in an unaligned pointer value [-Waddr=
ess-of-packed-member]

xfs_rmap_btree.c:188:15: warning: taking address of packed member of =E2=80=
=98struct xfs_rmap_key=E2=80=99 may result in an unaligned pointer value =
[-Waddress-of-packed-member]


Dave had sent a patch to turn the warning off globally, but that seems
like a big hammer, I dunno.  Here are 2 patches to work around it instead=
.

Not tested yet, just seeing how loud people may scream at the ideas.


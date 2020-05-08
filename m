Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9935E1CA196
	for <lists+linux-xfs@lfdr.de>; Fri,  8 May 2020 05:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgEHDbz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 23:31:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54995 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726683AbgEHDbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 23:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588908714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7IRdgTfSxIdoGrUtCPwrwd8l78trKkcv7w0J3JkNtbg=;
        b=Q8zE9c/Vmj5dUbQJy6MD2J7B+OPSMpQxHcKcXEIzUTArz59CjHl0dy5ur2USfuirz+jNMD
        OhJJHivfzNW9S8bEbdn4XvLL1cFQWYqMeIQElQDz4KFswiaodqoqtLn3ruLQkY3ZqUrENH
        UXtJDX0p+QOGk/xDy5o9csb/C5/ZjTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-vCD22Cu8PbSZxYp0kf-4GQ-1; Thu, 07 May 2020 23:31:53 -0400
X-MC-Unique: vCD22Cu8PbSZxYp0kf-4GQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26C55107ACCA
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 03:31:52 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFB0799CF
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 03:31:51 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: fix project quota ENOSPC vs EDQUOT
Message-ID: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
Date:   Thu, 7 May 2020 22:31:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently when project quota is enabled, group quota will return
ENOSPC vs EDQUOT.  This is the right error code for project quota
but not for group quota; this is an old bug left over from when they
were mutually exclusive.


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD36A25AD7F
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Sep 2020 16:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgIBOll (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Sep 2020 10:41:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728031AbgIBOlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 10:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599057668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZpQ0iRB/iOmHdrYmsdVi6RNxGXmxhziWrXltIOYZEBs=;
        b=Ur/kNUKcxT7meKkAudN5wALxEZnheOTOgDOaeGEGNseyaOZSTXrmfW5aInRWSus/dadn7W
        lOwLPf2bhVRHlPjg83imsM9BRKRkNoPuf8RNroy5aYhs7BV8kSuBz2y1NYHKXNgayn3w7j
        Wowh5O2iLasCTfU2AchfwcMeCU9NpxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-pwpVZvvQMP-UHOL_S2Pscw-1; Wed, 02 Sep 2020 10:41:06 -0400
X-MC-Unique: pwpVZvvQMP-UHOL_S2Pscw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D68D427C8
        for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2020 14:41:04 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.195.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7FCD7EEB8
        for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2020 14:41:03 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4 V2] Clean up xfs_attr_sf_entry
Date:   Wed,  2 Sep 2020 16:40:55 +0200
Message-Id: <20200902144059.284726-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

this is the V2 of the series to clean up the xfs_attr_sf_entry, addressing the
comments on the previous version.

Changelog details are in each patch description.

this series has been suggested by Eric, and it's intended as a small clean up
for xfs_attr_sf_entry usage.

In this series though, I reordered the typdef cleanups to be the first patches
in the series.

-- 
2.26.2


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53409AB49
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2019 11:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfHWJZn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 23 Aug 2019 05:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfHWJZn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Aug 2019 05:25:43 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 08F4210F23E9;
        Fri, 23 Aug 2019 09:25:43 +0000 (UTC)
Received: from pegasus.maiolino.com (unknown [10.40.205.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E03D60933;
        Fri, 23 Aug 2019 09:25:42 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] t_stripealign: Fix fibmap error handling
Date:   Fri, 23 Aug 2019 11:25:30 +0200
Message-Id: <20190823092530.11797-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 23 Aug 2019 09:25:43 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FIBMAP only returns a negative value when the underlying filesystem does
not support FIBMAP or on permission error. For the remaining errors,
i.e. those usually returned from the filesystem itself, zero will be
returned.

We can not trust a zero return from the FIBMAP, and such behavior made
generic/223 succeed when it should not.

Also, we can't use perror() only to print errors when FIBMAP failed, or
it will simply print 'success' when a zero is returned.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 src/t_stripealign.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/t_stripealign.c b/src/t_stripealign.c
index 5cdadaae..164831f8 100644
--- a/src/t_stripealign.c
+++ b/src/t_stripealign.c
@@ -76,8 +76,11 @@ int main(int argc, char ** argv)
 		unsigned int	bmap = 0;
 
 		ret = ioctl(fd, FIBMAP, &bmap);
-		if (ret < 0) {
-			perror("fibmap");
+		if (ret <= 0) {
+			if (ret < 0)
+				perror("fibmap");
+			else
+				fprintf(stderr, "fibmap error\n");
 			free(fie);
 			close(fd);
 			return 1;
-- 
2.20.1

